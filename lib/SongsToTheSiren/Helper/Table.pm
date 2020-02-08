package SongsToTheSiren::Helper::Table;
use Mojo::Base 'Mojolicious::Plugin';

# POD at end of source file

use SongsToTheSiren::Table::Factory;

sub register {
    my ($self, $app) = @_;

	$app->helper(table => sub {
		my ($c, $name, @args) = @_;
		state $table_factory = SongsToTheSiren::Table::Factory->new;
		return $table_factory->table($name, {c => $c, @args});
	});

}

1;

__END__


=pod

=head1 NAME

SongsToTheSiren::Helper::Table : helper to instantiate table views

=head1 SYNOPSIS

    # In app startup()
    $self->plugin('SongsToTheSiren::Helper::Table');

    # To instantiate a table, e.g.
    my $table = $c->table('Topic::List');
    $c->stash(table => $table);

=head1 DESCRIPTION

Provides a 'table' helper to create a table view

=head1 HELPERS

=over

=item table

  $c->table($some_partial_class_name);

Creates a table of type SongsToTheSiren::Table::$some_partial_class_name

=back

=head1 AUTHOR

David Stevenson david@ytfc.com

