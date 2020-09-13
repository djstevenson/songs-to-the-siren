package SongsToTheSiren::Task::SendMail;
use Mojo::Base 'Mojolicious::Plugin';

# POD docs at end of file

use Mojo::Template;
use Mojo::Home;
use Mojo::UserAgent;
use Mojo::URL;
use Mojo::JSON qw/ decode_json /;

use Net::SMTP::TLS;
use Carp;
use DateTime;

has home => sub { Mojo::Home->new; };

has host        => undef;
has user        => undef;
has password    => undef;
has from        => undef;
has site_domain => undef;
has json_conf   => undef;

sub register {
    my ($self, $app) = @_;

    # Load conf from ENV, if exists
    my $mode = uc $app->mode;

    my $env_name = "SONGSTOTHESIREN_${mode}_CONFIG";
    $self->json_conf(decode_json($ENV{$env_name})) if exists $ENV{$env_name};

    $self->host($self->_conf('host', $app));
    $self->user($self->_conf('user', $app));
    $self->password($self->_conf('password', $app));
    $self->from($self->_conf('from', $app));
    $self->site_domain($self->_conf('domain', $app));


    $self->home->detect;

    # Create a minion task to send an email
    $app->minion->add_task(
        smtp => sub {
            my ($job, $email_id) = @_;

            my $japp     = $job->app;
            my $schema   = $japp->schema;
            my $email_rs = $schema->resultset('Email');
            my $email    = $email_rs->find($email_id);

            return unless $email;

            my $template = $email->template_name;
            my $data     = $email->data;

            $data->{domain} = $self->site_domain;

            my $mt      = Mojo::Template->new;
            my $subject = $mt->vars(1)->render_file($self->_file(subject => $template), $data);
            my $body    = $mt->vars(1)->render_file($self->_file(body => $template), $data);

            my $from = $self->from;
            my $to   = $email->email_to;

            my ($localpart, $from_domain) = split(/\@/, $from);

            # TODO Default TLS config doesn't work with my
            #      ESP. Work out what does, and make it
            #      configurable.
            my $smtp = Net::SMTP::TLS->new(
                $self->host,
                NoTLS    => 1,
                Hello    => $from_domain,
                Timeout  => 60,
                User     => $self->user,
                Password => $self->password,
            );

            # TODO How do we make this task testable?
            # Plug in a mock object compatible with Net::SMTP::TLS?
            # It could simulate fails (e.g send to error503@example.com
            # to simulate that specific error?)
            $smtp->mail($from);
            $smtp->recipient($to);
            $smtp->data;
            $smtp->datasend("From: ${from}\n");
            $smtp->datasend("To: ${to}\n");
            $smtp->datasend("Subject: ${subject}\n\n");
            $smtp->datasend("${body}\n\n");
            $smtp->dataend;
            $smtp->quit;

            $email->update({
                sent_at =>  DateTime->now,
            });
        }
    );
    return;
}

# See POD for details on how we pick up config
sub _conf {
    my ($self, $key, $app) = @_;

    return $self->json_conf->{$key} if exists $self->json_conf->{$key};

    return $app->config->{smtp}->{$key} if exists $app->config->{smtp}->{$key};

    croak "Not found smtp config for '$key'";
}

# Locates a template file
sub _file {
    my ($self, $type, $template) = @_;

    return $self->home->child('templates', 'email', $template, "${type}.text.ep");

}

1;
__END__

=pod

=head1 NAME

SongsToTheSiren::Task::SMTP : Plugin to send email

=head1 SYNOPSIS

    # In app startup()
    $self->plugin('SongsToTheSiren::Task::SendMail');

    # When you want to send an email:
    $app->minion->enqueue(smtp => [ $email_id ]);

=head1 DESCRIPTION

Provides a Minion task for sending emails through SMTP.

=head1 TEST MODE

If $app->mode is 'test', then sending is skipped.

This is enforced by SongsToTheSiren::Helper::Email

=head1 CONFIGURATION

You will need to configure a from address, a host and user/password
credentials. I recommend doing this via the environment so that secrets
aren't checked into your app's repo.

=over

=item from

Set via JSON in the environment. The env name is
mode-dependent, so will be one of:

  SONGSTOTHESIREN_DEVELOPMENT_CONFIG=...
  SONGSTOTHESIREN_TEST_CONFIG=...
  SONGSTOTHESIREN_PRODUCTION_CONFIG=...

Within the JSON defined there, the value corresponding to the
'from' key will be selected.

If not present, we'll look in the app config file, e.g.

    smtp => {
        from => 'noreply@example.com',
        ...
    }


=item host

The SMTP host that sends your mails.

Set via the env JSON, keyname is 'host', or
set via the app config file, e.g.

    smtp => {
        host => 'smtp.example.com',
        ...
    }

=item user

The user name for authenticating to your SMTP server.

Set via the env JSON, keyname is 'user', or
set via the app config file, e.g.

    smtp => {
        user => 'mymailuser',
        ...
    }

=item password

The password for authenticating to your SMTP server.

Set via the env JSON, keyname is 'password', or
set via the app config file, e.g.

    smtp => {
        password => 'mymailpassword',
        ...
    }

=item domain

The domain for emailed links, including the protocol
(and port, if required)

Set via the env JSON, keyname is 'domain', or
set via the app config file, e.g.

    smtp => {
        domain => 'https://songstothesiren.com',
        ...
    }

(TODO: We might need this for reasons other than
SMTP, so should this be defined elsewhere in the 
config?)

=back

=head1 AUTHOR

David Stevenson david@ytfc.com
