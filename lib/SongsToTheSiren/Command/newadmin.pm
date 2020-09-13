package SongsToTheSiren::Command::newadmin;
use Mojo::Base 'Mojolicious::Command';

use Mojo::Util 'getopt';

has description => 'Create an admin user in an empty DB';

# Usage message from SYNOPSIS
has usage => sub { shift->extract_usage };

sub run {
    my ($self, @args) = @_;

    getopt(\@args, 'n|name=s' => \my $name, 'e|email=s' => \my $email, 'p|password=s' => \my $password);

    if ($name && $email && $password) {
        my $app     = $self->app;
        my $schema  = $app->schema;
        my $user_rs = $schema->resultset('User');

        $user_rs->create_user({name => $name, email => $email, password => $password, admin => 1,});
    }

    return;
}

=head1 SYNOPSIS

  Usage: APPLICATION newadmin [OPTIONS]

  Options:
    -n, --name     The user name (required)
    -e, --email    The user email (required)
    -p, --password The user plaintext password (required)

  Example: --name=davids --email=davids@example.com --password=b0bb1n5

=cut

1;
