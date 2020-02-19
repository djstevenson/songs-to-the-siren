package SongsToTheSiren::Task::SendMail;
use Mojo::Base 'Mojolicious::Plugin';

# POD docs at end of file

use Mojo::Template;
use Mojo::Home;
use Mojo::UserAgent;
use Mojo::URL;

use Net::SMTP::TLS;

has home     => sub { Mojo::Home->new; };

has host     => undef;
has user     => undef;
has password => undef;
has from     => undef;

sub register {
    my ($self, $app, $conf) = @_;

    # Set config from $ENV, passed conf, or from app config files
    # in that order.
    $self->host    ( $self->_conf('host',     $app, $conf) );
    $self->user    ( $self->_conf('user',     $app, $conf) );
    $self->password( $self->_conf('password', $app, $conf) );
    $self->from    ( $self->_conf('from',     $app, $conf) );

    $self->home->detect;

    # Create a minion task to send an email
    $app->minion->add_task(smtp => sub {
        my ($job, $email_id) = @_;

        my $app = $job->app;
        my $schema = $app->schema;
        my $email_rs = $schema->resultset('Email');
        my $email = $email_rs->find($email_id);

        return unless $email;

        my $template = $email->template_name;
        my $data     = $email->data;

        my $mt = Mojo::Template->new;
        my $subject = $mt->vars(1)->render_file($self->_file(subject => $template), $data);
        my $body    = $mt->vars(1)->render_file($self->_file(body    => $template), $data);
        
        my $from = $self->from;
        my $to   = $email->email_to;

        my ($localpart, $domain) = split(/\@/, $from);

        # TODO Default TLS config doesn't work with my 
        #      ESP. Work out what does, and make it 
        #      configurable.
        my $smtp = Net::SMTP::TLS->new(
            $self->host,
            NoTLS    => 1,
            Hello    => $domain,
            Timeout  => 60,
            User     => $self->user,
            Password => $self->password,
        );

        $smtp->mail($from);
        $smtp->recipient($to);
        $smtp->data;
        $smtp->datasend("From: ${from}\n");
        $smtp->datasend("To: ${to}\n");
        $smtp->datasend("Subject: ${subject}\n\n");
        $smtp->datasend("${body}\n\n");
        $smtp->dataend;
        $smtp->quit;
    });
}

# See POD for details on how we pick up config
sub _conf {
    my ($self, $key, $app, $conf) = @_;

    my $env_name = 'SONGSTOTHESIREN_SMTP_' . uc($key);
    print "   Try env $env_name\n";
    return $ENV{$env_name} if exists $ENV{$env_name};

    print "   Try conf->$key\n";
    return $conf->{$key} if exists $conf->{$key};

    print "   Try app->config->{smtp}->{$key}\n";
    return $app->config->{smtp}->{$key} if exists $app->config->{smtp}->{$key};

    die "Not found smtp config for '$key'";
}

# Locates a template file
sub _file {
    my ($self, $type, $template) = @_;

    return $self->home->child(
        'templates',
        'email',
        $template,
        "${type}.text.ep"
    );

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

=item from address

Set via the environment, e.g.
    export SONGSTOTHESIREN_SMTP_FROM=noreply@example.com

Or set via the app config file, e.g.

    smtp => {
        from => 'noreply@example.com',
        ...
    }


=item host

The SMTP host that sends your mails.

Set via the environment, e.g.
    export SONGSTOTHESIREN_SMTP_USER=smtp.example.com

Or set via the app config file, e.g.

    smtp => {
        domain => 'smtp.example.com',
        ...
    }

=item user

The user name for authenticating to your SMTP server.

Set via the environment, e.g.
    export SONGSTOTHESIREN_SMTP_USER=mymailuser

Or set via the app config file, e.g.

    smtp => {
        user => 'mymailuser',
        ...
    }

=item password

The password for authenticating to your SMTP server.

Set via the environment, e.g.
    export SONGSTOTHESIREN_SMTP_USER=mymailpassword

Or set via the app config file, e.g.

    smtp => {
        password => 'mymailpassword',
        ...
    }

=item ...

TODO: Allow more config options

=back

=head1 AUTHOR

David Stevenson david@ytfc.com
