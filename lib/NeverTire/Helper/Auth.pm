package NeverTire::Helper::Auth;
use Mojo::Base 'Mojolicious::Plugin';

# POD at end of source file

use NeverTire::Schema;

sub register {
    my ($self, $app) = @_;


    $app->helper(auth_user => sub {
        my $c = shift;

        return unless exists $c->stash->{auth_user};
        return $c->stash->{auth_user};
    });

    $app->helper(assert_user => sub {
        my $c = shift;

        my $user = $c->auth_user or die;
        return $user;
    });

    $app->helper(assert_admin => sub {
        my $c = shift;

        my $user = $c->assert_user;
        die unless $user->admin;
        return $user;
    });

}

1;

__END__


=pod

=head1 NAME

NeverTire::Helper::Auth : helper for authorisation functionality

=head1 SYNOPSIS

    # In app startup()
    $self->plugin('NeverTire::Helper::Auth');

    my $user = $c->auth_user;  # etc ...

=head1 DESCRIPTION

Provides a authorisation-related helper methods as listed below

=head1 HELPERS

=over

=item auth_user

    my $user = $c->auth_user

Returns the user object of the logged-in user - if no-one
is logged-in we return undef. Use this where auth is optional
but you want to know the user if there is one.

=item assert_user

    my $user = $c->assert_user

Returns the user object of the logged-in user - if no-one
is logged-in this method does not return but throws an exception.

=item assert_admin

    my $user = $c->assert_admin

Returns the user object of the logged-in ADMIN user - if no-one
is logged-in, or someone is logged-in but isn't admin, this method
does not return but throws an exception.

=back

=head1 AUTHOR

David Stevenson david@ytfc.com

