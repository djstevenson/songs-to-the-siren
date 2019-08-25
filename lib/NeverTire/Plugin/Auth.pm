package NeverTire::Plugin::Auth;

use Mojo::Base 'Mojolicious::Plugin';
use Carp;

# POD docs at end of file

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

=pod

=head1 NAME

NeverTire::Plugin::Auth : Plugin to create routes that check auth

=head1 SYNOPSIS

    # In app startup()
    $self->plugin('NeverTire::Plugin::Auth');

    # In your routes setup:
    $route->require_login->...;

    $route->require_admin->...;

=head1 DESCRIPTION

Provides route methods that check for auth users.

=head1 ROUTES

=over

=item require_login

In your routes, use 'require_login' when you require an authenticated user
for a controller action:

    $route->require_login->any('/comment')->to(controller => ...);

Ends the request and returns a 403 http status if there is no
authenticated user.

=item require_admin

In your routes, use 'require_admin' when you require an authenticated
ADMIN user for a controller action:

    $route->require_admin->any('/blah')->to(controller => ...);

Ends the request and returns a 403 http status if there is no
authenticated user, or if there is an authenticated user but they are
not an admin.

=back

=head1 AUTHOR

David Stevenson david@ytfc.com
