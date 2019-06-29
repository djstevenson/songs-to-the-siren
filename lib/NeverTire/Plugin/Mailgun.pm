package NeverTire::Plugin::Mailgun;

use Mojo::Base 'Mojolicious::Plugin';

use Mojo::Template;
use Mojo::Home;

use Carp;

# Includes ideas from Mojolicious::Plugin::Mailgun
# https://metacpan.org/pod/Mojolicious::Plugin::Mailgun

has base_url => sub { Mojo::URL->new('https://api.mailgun.net/v3/'); };
has ua       => sub { Mojo::UserAgent->new; };
has home     => sub { Mojo::Home->new; };
has domain   => undef;
has api_key  => undef;
has from     => undef;

sub register {
    my ($self, $app, $conf) = @_;

    # Set config from $ENV, passed conf, or from app config files
    # in that order.
    $self->domain ( $self->_conf('domain',  $app, $conf) );
    $self->api_key( $self->_conf('api_key', $app, $conf) );
    $self->from   ( $self->_conf('from',    $app, $conf) );

    $self->home->detect;

    $app->helper('mailgun.send' => sub {
        my ($c, $to, $template, $data) = @_;

        use Data::Dumper;
        my $mt = Mojo::Template->new;
        my $subject = $mt->vars(1)->render_file($self->_file(subject => $template), $data);
        my $body    = $mt->vars(1)->render_file($self->_file(body    => $template), $data);
        print STDERR "DATA=", Dumper($data);

        print STDERR "SUBJECT=$subject\n";
        print STDERR "BODY=$body\n\n\n";
        
        # TODO Actually send it!!
        die 'not yet able to send mails';
    });

    return;
}

# Doc this. If $key is 'api_key', it looks in these places in order:
#  * $ENV{NEVER_TIRE_MAILGUN_API_KEY}
#  * $conf->{api_key}
#  * $app->conf->{mailgun}->{api_key}

sub _conf {
    my ($self, $key, $app, $conf) = @_;

    my $env_name = 'NEVER_TIRE_MAILGUN_' . uc($key);
    return $ENV{$env_name} if exists $ENV{$env_name};

    return $conf->{$key} if exists $conf->{$key};

    return $app->config->{mailgun}->{$key} if exists $app->config->{mailgun}->{$key};

    die "Not found mailgun config for '$key'";
}

# Doc this, locates a template file

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

# TODO pod docs
