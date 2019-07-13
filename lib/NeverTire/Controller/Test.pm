package NeverTire::Controller::Test;
use Mojo::Base 'Mojolicious::Controller';

# See end of source file for POD docs



#################################################
####### ONLY VALID ON never_tire_test DB  #######
#######                                   #######
####### DON'T USE THAT DB IN PRODUCTION!! #######
#################################################

sub add_routes {
    my ($c, $route) = @_;

    # Don't need to be logged in for these actions
    my $t = $route->any('/test')->to(controller => 'test');

    $t->route('/create_user/:username')->name('test_create_user')->via('GET')->to(action => 'create_user');
    $t->route('/confirm_user/:username')->name('test_confirm_user')->via('GET')->to(action => 'confirm_user');
    $t->route('/view_user/:username')->name('test_view_user')->via('GET')->to(action => 'view_user');
    $t->route('/set_user_flag/:userid/:flagname')->name('test_set_user_flag')->via('GET')->to(action => 'set_user_flag');
    $t->route('/clear_user_flag/:userid/:flagname')->name('test_clear_user_flag')->via('GET')->to(action => 'clear_user_flag');
    $t->route('/view_email/:type/:username')->name('test_view_email')->via('GET')->to(action => 'view_email');

}

sub create_user {
    my $c = shift;

    my $rs = $c->schema->resultset('User');
    my $user = $rs->create_test_user($c->stash->{username});

    $c->stash(
        user     => $user,
        template => 'test/user',
    );
}

sub confirm_user {
    my $c = shift;

    my $user = $c->_find_user_by_name;
    my $key  = $user->find_key('registration');
    $user->confirm_registration($key);
    
    $c->stash(
        user     => $user,
        template => 'test/user',
    );
}

sub _find_user_by_name {
    my $c = shift;

    my $rs = $c->schema->resultset('User');
    return $rs->search({
        name => $c->stash->{username}
    })->single;
}

sub view_user {
    my $c = shift;

    my $user = $c->_find_user_by_name;

    if ($user) {
        $c->stash(
            user     => $user,
            template => 'test/user',
        );
        return 1;
    }

    $c->reply->not_found;
}

# Permissions and prefs
sub set_user_flag {
    my $c = shift;

    $c->_user_flag(1);
}

sub clear_user_flag {
    my $c = shift;

    $c->_user_flag(0);
}

my $_valid_flags = { map { ($_ => 1 )} qw/ admin post banned pm topic_view live_preview updates / };

sub _user_flag {
    my ($c, $value) = @_;

    my $user = $c->schema->resultset('User')->find($c->stash->{userid});
    my $flag = $c->stash->{flagname};
    die unless exists $_valid_flags->{$flag};
    $user->update({
        $flag => $value
    });

    $c->stash(
        user     => $user,
        template => 'test/user',
    );
}

sub view_email {
    my $c = shift;

    my $user = $c->_find_user_by_name;

    if ($user) {
        my $email = $c->schema
            ->resultset('Email')
            ->latest_email(
                $c->stash->{type},
                $user->email,
            );

        if ($email) {
            $c->stash(
                email    => $email,
                template => 'test/email',
            );
            return 1;
        }
    }

    $c->stash(template => 'test/email_not_found');
}

1;

=pod

=head1 NAME

Forum::Controller::Test : Controller for actions that support automated testing

=head1 SYNOPSIS

	my $test_controller = Forum::Controller::Test->new;
	$test_controller->add_routes($not_loggedin_base_route, $loggedin_base_route);

=head1 DESCRIPTION

Declares /test routes, and provides the actions for those routes.

ONLY INCLUDED IF YOUR TEST DB IS CALLED never_tire_test AND
THE ENV VAR "MOJO_MODE" is set to "TEST" (both checks are case sensitive)

=head1 METHODS

=over

=item add_routes

	$test_controller->add_routes($not_loggedin_base_route, $loggedin_base_route);

Adds /test routes to the base / routes. Two base routes are passed-in, the first
does not enforce login, but the second does. This controller only uses the latter,
i.e. all actions require a logged-in user.

=back

=head1 ACTIONS

=over

=item /test/create_user/:username

Creates a user with no permissions.

:username is the name. From this we will generate
an email address as lower-cased-username@example.com
and a password of PW<space>lower-cased-username

=item /test/confirm_user/:username

Marks a user-registration as confirmed. This short-cuts
any registration-key checks etc, it just updates the user
record.

=item /test/view_user/:username

Renders a template detailing the user record so we can
verify it. Yeah, that's not a functional test, but
it's handy anyway.

The template is a table, one row per field, with the value
rendered as, for example:

  <td id="user-name"><%= $user->name %></td>


=item /test/view_email/:type/:address

Finds the most recent email of the specified type
(e.g. 'registration') for the given email address.

The email address should replace dots with
double underscore, e.g.
 /test/view_email/registration/david%40ytfc__com

cos other wise the ".com" ending tells Mojolicious to
look for a template of that name.

Renders the record in a similar manner to the
user view template mentioned above.

The data field is rendered as a sub-table with values
as, for example, 

  <td id="email-data-key"><%= $email->data->key %></td>

This isn't a functional test in itself, but it
allows a test to find the registration confirm/decline URLs
for a test user.

=back

=head1 AUTHOR

David Stevenson david@ytfc.com

=cut

