package NeverTire;
use Mojo::Base 'Mojolicious';

# POD docs at end of source

use NeverTire::Schema;

use NeverTire::Controller::Home;
use NeverTire::Controller::User;
use NeverTire::Controller::Song;
use NeverTire::Controller::Markdown;

# This method will run once at server start
sub startup {
    my $app = shift;

    # Load configuration from hash returned by "never-tire.conf"
    $app->plugin('Config');

    # Command-line plugins:
    push @{ $app->commands->namespaces }, 'NeverTire::Command';

    $app->secrets($app->config->{secrets});

    $app->plugin('NeverTire::Helper::DB');
    $app->plugin('NeverTire::Helper::Form');
    $app->plugin('NeverTire::Helper::Table');
    $app->plugin('NeverTire::Helper::Render');

    $app->_migrate_db;

    my $routes = $app->_base_routes;

    my $user_controller = NeverTire::Controller::User->new;
	$user_controller->add_routes($routes);

    my $home_controller = NeverTire::Controller::Home->new;
    $home_controller->add_routes($routes);

    my $song_controller = NeverTire::Controller::Song->new;
    $song_controller->add_routes($routes);

    my $markdown_controller = NeverTire::Controller::Markdown->new;
    $markdown_controller->add_routes($routes);
}

use Mojo::Pg;
use Mojo::Pg::Migrations;
use Mojo::Home;

# TODO docs
sub _base_routes {
    my $app = shift;

    my $route_all = $app->routes;

    # Route for "must be logged in"
    my $route_login = $route_all->under('/' => sub {
    	my $c = shift;

        # Logged in?
        if (my $user_id = $c->session->{user}) {
            if (my $user = $c->schema->resultset('User')->find($user_id)) {
                $c->stash->{auth_user} = $user;
                return 1;
            }
        }

        delete $c->session->{user};
        $c->stash->{auth_user} = undef;
        $c->reply->not_found;
        return undef;
    });

    # Route for "must be logged in"
    my $route_admin = $route_login->under('/' => sub {
    	my $c = shift;

        # Already logged-in because coming via $route_login
        if (! $c->stash->{auth_user}->admin) {
            $c->reply->not_found;
            return undef;
        }

        return 1;
    });

    return {
        all   => $route_all,
        login => $route_login,
        admin => $route_admin,
    }
}

sub _migrate_db {
    my $app = shift;

    my $schema = $app->schema;
    my $db_name = $app->db_name;

    my $pg = Mojo::Pg->new("postgresql://nevertire\@localhost/$db_name");
    my $migrations = Mojo::Pg::Migrations->new(pg => $pg);

    my $home = Mojo::Home->new->detect;
    my $sql = $home->child('tools', 'migrations.sql');

    print "Applying migrations from $sql\n";
    $migrations->from_file($sql)->migrate;
}

1;

=pod

=head1 NAME

NeverTire : The app class for the blog

=head1 SYNOPSIS

Run via the Mojolicious startup script, which will call:

 Mojolicious::Commands->start_app('NeverTire');

=head1 DESCRIPTION

The app startup module for the blog. Implements the 'startup' method which bootsteps the app.

=head1 METHODS

=over

=item startup

Takes no args. This is called when the blog app is started via script/never-tire

It loads the config, plugins, and sets up the routes.

=back

=head1 AUTHOR

David Stevenson david@ytfc.com

=cut
