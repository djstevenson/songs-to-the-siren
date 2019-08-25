package NeverTire::Controller::Test;
use Mojo::Base 'Mojolicious::Controller';

# See end of source file for POD docs

use DateTime;

#################################################
####### ONLY VALID ON never_tire_test DB  #######
#######                                   #######
####### DON'T USE THAT DB IN PRODUCTION!! #######
#################################################


# TODO Replace all this with proper admin pages

sub add_routes {
    my ($c, $route) = @_;

    # Don't need to be logged in for these actions
    my $t = $route->any('/test')->to(controller => 'test');

    $t->route('/reset')->name('test_reset')->via('POST')->to(action => 'reset');
    $t->route('/create_user')->name('test_create_user')->via('POST')->to(action => 'create_user');
    $t->route('/create_song')->name('test_create_song')->via('POST')->to(action => 'create_song');
    $t->route('/publish_song')->name('test_publish_song')->via('POST')->to(action => 'publish_song');
    $t->route('/view_user/:username')->name('test_view_user')->via('GET')->to(action => 'view_user');
    $t->route('/view_email/:type/:username')->name('test_view_email')->via('GET')->to(action => 'view_email');
}

sub reset {
    my $c = shift;

    $c->schema->resultset('Tag')->delete;
    $c->schema->resultset('Song')->delete;
    $c->schema->resultset('Song')->delete;
    $c->redirect_to('home');
}

sub create_user {
    my $c = shift;

    my $name     = $c->param('name')     or die;
    my $email    = $c->param('email')    or die;
    my $password = $c->param('password') or die;
    my $admin    = $c->param('admin')    // 0;

    my $rs = $c->schema->resultset('User');
    my $user = $rs->create_test_user($name, $email, $password, $admin);

    $c->stash(
        user     => $user,
        template => 'test/user',
    );
}

sub create_song {
    my $c = shift;

    my $username = $c->param('username') || die;
    my $user     = $c->_find_user_by_name($username);
    die unless $user->admin;

    my $published = $c->param('published')
        ? DateTime->now
        : undef;

    my $fields = {
        title            => $c->param('title'),
        artist           => $c->param('artist'),
        album            => $c->param('album'),
        image            => $c->param('image'),
        country_id       => $c->param('country_id'),
        released_at      => $c->param('released_at'),
        summary_markdown => $c->param('summary'),
        full_markdown    => $c->param('full'),
        published_at     => $published,
    };
	$user->admin_create_song($fields);

    $c->redirect_to('home');
}

sub publish_song {
    my $c = shift;

    my $title = $c->param('title') || die;
    my $song  = $c->_find_song_by_title($title);
    my $flag  = $c->param('published');

    if ($flag) {
        $song->show;
    }
    else {
        $song->hide;
    }

    $c->redirect_to('home');
}

sub _find_user_by_name {
    my ($c, $username) = @_;

    my $rs = $c->schema->resultset('User');
    return $rs->search({ name => $username })->single;
}

sub _find_song_by_title {
    my ($c, $title) = @_;

    my $rs = $c->schema->resultset('Song');
    return $rs->search({ title => $title })->single;
}

sub view_user {
    my $c = shift;

    my $user = $c->_find_user_by_name($c->stash->{username});

    if ($user) {
        $c->stash(
            user     => $user,
            template => 'test/user',
        );
        return 1;
    }

    $c->reply->not_found;
}

sub view_email {
    my $c = shift;

    my $user = $c->_find_user_by_name($c->stash->{username});

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

    $c->reply->not_found;
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

=item /test/create_user (POST only)

Creates a 'confirmed' user with the given name, email, password.

And, optionally, with the admin flag.

POST only.

=head2 Params

name, email, password

Optional: admin, 1 if user is to be admin, 0 otherwise


=item /test/create_song (POST only)

Creates an optionally-published song with the given deets.

POST only.

=head2 Params

title, artist, album, country_id, summary, full, username, released_at

Optional: published, 1 if song is to be published, 0 otherwise

=item /test/publish_song (POST only)

Publishes, or unpublishes, a song. This is not a RESTy way of
doing it, but it's only for test code.

POST only.

=head2 Params

=over

=item title

Title of song (tests don't deal with Database IDs)

=item published

Flag, some true value means set song to published=NOW(), some
false value means set song to published=NULL.

=back

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

