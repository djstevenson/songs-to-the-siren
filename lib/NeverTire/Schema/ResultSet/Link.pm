package NeverTire::Schema::ResultSet::Link;
use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';

# POD docs at end of this source file

use Carp qw/ croak /;

sub by_priority {
    my $self = shift;

    return $self->search(undef, {
        order_by => 'priority'
    });
}

__PACKAGE__->meta->make_immutable;
1;

=pod

=head1 NAME

NeverTire::Schema::ResultSet::Link : ResultSet subclass for links

=head1 SYNOPSIS

    $song->links->by_priority-> ...;

=head1 DESCRIPTION

ResultSet methods for Links

=head1 METHODS

=over

=item by_pubdate

A simple helper, for readability, to order
links by priority. Low number = high priority,
so sort is 'ascending'.

=back

=head1 AUTHOR

David Stevenson david@ytfc.com

=cut

