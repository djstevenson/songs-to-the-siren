package SongsToTheSiren::Helper::DB;
use Mojo::Base 'Mojolicious::Plugin';

# POD at end of source file

use SongsToTheSiren::Schema;

sub register {
    my ($self, $app) = @_;

    $app->helper(
        db_name => sub {
            my $c = shift;

            return $c->config->{db_name};
        }
    );

    $app->helper(
        db_dsn => sub {
            my $c = shift;

            return 'postgresql://songstothesiren@localhost/' . $c->db_name;
        }
    );

    my $conn = SongsToTheSiren::Schema->connect('dbi:Pg:dbname=' . $app->db_name, 'songstothesiren', undef);
    $app->helper(
        schema => sub {

            # TODO Check connection is still alive, reconnect if not?
            return $conn;
        }
    );

}

1;

__END__


=pod

=head1 NAME

SongsToTheSiren::Helper::DB : helper to get a DB schema

=head1 SYNOPSIS

    # In app startup()
    $self->plugin('SongsToTheSiren::Helper::DB');

    # To get a DBIx::Class schema
    my $schema = $c->schema;

=head1 DESCRIPTION

Provides a 'schema' helper to get a DBIx::Class schema object

=head1 HELPERS

=over

=item db_name

  $c->db_name

Gets the database name

=item schema

  $c->schema

Gets a DBIx::Class schema

You can call, for example

 $c->schema->resultset('User')

to create a users resultset.

=back

=head1 AUTHOR

David Stevenson david@ytfc.com

