package NeverTire::Plugin::Auth;

use Mojo::Base 'Mojolicious::Plugin';
use Carp;

sub register {
    my ($self, $app, $conf) = @_;

    my $root = $app->routes;

    $root->add_shortcut(require_login => sub {
        my ($r, @args) = @_;
        return $r->under(@args)->to(cb => \&_require_login);
    });

    $root->add_shortcut(require_admin => sub {
        my ($r, @args) = @_;
        return $r->under(@args)->to(cb => \&_require_admin);
    });

    return;
}

sub _require_login {
    my $c = shift;

    return 1 if exists $c->stash->{auth_user};

    $c->render(status => 403, text => 'I do not think so');
    return;
}

sub _require_admin {
    my $c = shift;

    return 1 if exists $c->stash->{admin_user};

    $c->render(status => 403, text => 'I really do not think so');
    return;
}

1;
__END__

# TODO pod docs
