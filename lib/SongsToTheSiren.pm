package SongsToTheSiren;
use utf8;
use Mojo::Base 'Mojolicious';

# POD docs at end of source

use SongsToTheSiren::Schema;

use SongsToTheSiren::Controller::Home;
use SongsToTheSiren::Controller::User;
use SongsToTheSiren::Controller::Song;
use SongsToTheSiren::Controller::Markdown;
use SongsToTheSiren::Controller::Content;
use SongsToTheSiren::Controller::Admin;
use SongsToTheSiren::Controller::Test;

# This method will run once at server start
sub startup {
    my $app = shift;

    # Load configuration from hash returned by "songs-to-the-siren.conf"
    $app->plugin('Config');

    # Command-line plugins:
    push @{$app->commands->namespaces}, 'SongsToTheSiren::Command';

    $app->secrets($app->config->{secrets});

    $app->plugin('SongsToTheSiren::Helper::DB');
    $app->plugin('SongsToTheSiren::Helper::Form');
    $app->plugin('SongsToTheSiren::Helper::Table');
    $app->plugin('SongsToTheSiren::Helper::Render');
    $app->plugin('SongsToTheSiren::Plugin::Auth');
    $app->plugin(Minion => {Pg => $app->db_dsn});
    $app->plugin('SongsToTheSiren::Helper::Email');
    $app->plugin('SongsToTheSiren::Task::SendMail');

    $app->_migrate_db;

    my $route = $app->_base_route;

    # Status page, if admin
    my $a            = $route->any(q{/})->require_admin;
    my $status_route = $a->name('status_home')->any('/status');
    $app->plugin('Status' => {route => $status_route});

    my $user_controller = SongsToTheSiren::Controller::User->new;
    $user_controller->add_routes($route);

    my $home_controller = SongsToTheSiren::Controller::Home->new;
    $home_controller->add_routes($route);

    my $song_controller = SongsToTheSiren::Controller::Song->new;
    $song_controller->add_routes($route);

    my $content_controller = SongsToTheSiren::Controller::Content->new;
    $content_controller->add_routes($route);

    my $markdown_controller = SongsToTheSiren::Controller::Markdown->new;
    $markdown_controller->add_routes($route);

    my $admin_controller = SongsToTheSiren::Controller::Admin->new;
    $admin_controller->add_routes($route);

    # Two conditions required for enabling test endpoints
    # MOJO_MODE=TEST and the db name must be songstothesiren_test
    if ($app->mode eq 'test' && $app->db_name eq 'songstothesiren_test') {
        my $test_controller = SongsToTheSiren::Controller::Test->new;
        $test_controller->add_routes($route);
    }

    return;
}

use Mojo::Pg;
use Mojo::Pg::Migrations;
use Mojo::Home;

# Private method:
# Constructs a common base for all routes. The only
# action taken here is to detect if we have an
# authenticated user, and update stash accordingly:
#
# auth_user  : Set to the user object if logged-in
# admin_user : Set to the user object if logged-in and is admin
#
# 'user object' is an instance of L<SongsToTheSiren::Schema::Result::User>

sub _base_route {
    my $app = shift;

    # Base of all routes. Works out if you're logged in,
    # but doesn't fail if you're not. Stores the logged-in
    # user (if exists) in $c->stash->{auth_user}. If that user
    # is admin, it's also stored in $c->stash->{admin_user}

    return $app->routes->under(
        q{/} => sub {
            my $c = shift;

            # Logged in?
            if (my $user_id = $c->session->{user}) {
                if (my $user = $c->schema->resultset('User')->find($user_id)) {
                    $c->stash->{auth_user}  = $user;
                    $c->stash->{admin_user} = $user if $user->admin;
                    return 1;
                }
            }

            # Not logged in. Delete any lingering user data
            # in session.
            delete $c->session->{user};

            return 1;
        }
    );
}

# Private method to apply migrations from tools/migrations.sql
sub _migrate_db {
    my $app = shift;

    my $schema  = $app->schema;
    my $db_name = $app->db_name;

    my $pg         = Mojo::Pg->new("postgresql://songstothesiren\@localhost/$db_name");
    my $migrations = Mojo::Pg::Migrations->new(pg => $pg);

    my $home = Mojo::Home->new->detect;
    my $sql  = $home->child('tools', 'migrations.sql');

    print "Applying migrations from $sql\n";
    $migrations->from_file($sql)->migrate;

    return;
}

1;

=encoding utf8

=head1 NAME

SongsToTheSiren : The app class for the blog

=head1 SYNOPSIS

Run via the Mojolicious startup script, which will call:

 Mojolicious::Commands->start_app('SongsToTheSiren');

=head1 DESCRIPTION

The app startup module for the blog. Implements the 'startup' method which bootsteps the app.

=head1 METHODS

=over

=item startup

Takes no args. This is called when the blog app is started via script/songs-to-the-siren

It loads the config, plugins, and sets up the routes.

=back

=head1 AUTHOR

David Stevenson david@ytfc.com

=cut
