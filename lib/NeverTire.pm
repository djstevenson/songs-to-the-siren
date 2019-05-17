package NeverTire;
use Mojo::Base 'Mojolicious';

# POD docs at end of source

# This method will run once at server start
sub startup {
    my $self = shift;

    # Load configuration from hash returned by "never-tire.conf"
    $self->plugin('Config');

    $self->secrets($self->config->{secrets});

    $self->plugin('NeverTire::Helper::DB');

    $self->_migrate_db;
}

use Mojo::Pg;
use Mojo::Pg::Migrations;
use Mojo::Home;

sub _migrate_db {
    my $self = shift;

    my $schema = $self->schema;
    my $db_name = $self->db_name;

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
