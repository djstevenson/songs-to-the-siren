package NeverTire::Schema::ResultSet::Link;
use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';

# POD docs at end of this source file

use Carp qw/ croak /;

sub by_priority {
    my $self = shift;

    return $self->search(undef, {
        order_by => { -asc => 'priority' },
    });
}

sub for_song {
    my ($self, $song) = @_;
    
    return $self->search({
        song_id => $song->id,
    })
}

sub links_by_identifier {
    my $self = shift;

    my %links = map {
        ($_->identifier => $_)
    } $self->all;

    return \%links;
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

=item by_priority

A simple helper, for readability, to order
links by priority. Low number = high priority,
so sort is 'ascending'.

=item for_song

A simple helper, restricts the resultset to links
for a given song.

=item links_by_identifier

Returns the links in the current result set as
a hash, keyed by link identifier. Values are result
objects.

So, this will return an HASHREF of records,
keyed by identifier. So this only makes sense if the
resultset is already constrainted by song_id.

e.g. $rs->for_song($song)->links_by_identifier;

=back

=head1 AUTHOR

David Stevenson david@ytfc.com

=cut

