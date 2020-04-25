package SongsToTheSiren::Schema::ResultSet::Link;
use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';

# POD docs at end of this source file

use Carp qw/ croak /;

sub in_list {
    my $self = shift;

    return $self->search({
        priority => { '>' => 0 },
    });
}

sub by_priority {
    my $self = shift;

    return $self->search(undef, {
        order_by => { -asc => [qw/ priority id /] },
    });
}

sub links_by_identifier {
    my $self = shift;

    my %links = map {
        ($_->identifier => $_)
    } $self->all;

    return \%links;
}

# TODO Viewing an article will call both links_by_identifier
# and list_links.  Therefore two queries. If the blog
# gets remotely busy, sort this out, do a single query
# for both views.
# This method returns a resultset
sub links_list {
    my $self = shift;

    return $self->in_list->by_priority;
}



__PACKAGE__->meta->make_immutable;
1;

=pod

=head1 NAME

SongsToTheSiren::Schema::ResultSet::Link : ResultSet subclass for links

=head1 SYNOPSIS

    $song->links->by_priority-> ...;

=head1 DESCRIPTION

ResultSet methods for Links

=head1 METHODS

=over

=item in_list

A simple helper, for readability, to select only links
that appear in the list at the end of an article.
Basically just does (where) "priority > 0"

=item by_priority

A simple helper, for readability, to order
links by priority. Low number = high priority,
so sort is 'ascending'.

=item links_by_identifier

Returns the links in the current result set as
a hash, keyed by link identifier. Values are result
objects.

So, this will return an HASHREF of records,
keyed by identifier. So this only makes sense if the
resultset is already constrainted by song_id.

e.g. $song->links_by_identifier;

=item links_list 

Returns the ordered list of links for the list at the
end of an article. A shortcut for

 $rs->in_list->by_priority

=back

=head1 AUTHOR

David Stevenson david@ytfc.com

=cut

