package SongsToTheSiren::Schema::ResultSet::Link;
use utf8;
use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';

# POD docs at end of this source file

use Carp qw/ croak /;

sub in_list {
    my $self = shift;

    return $self->search({
        list_priority => {'>' => 0}
    });
}

sub by_priority {
    my $self = shift;

    return $self->search(undef, {
        order_by => {-asc => [qw/ list_priority id /]}
    });
}

sub embedded_links {
    my $self = shift;

    return $self->search({
        embed_identifier => { q{!=} => q{} }
    });
}

sub by_identifier {
    my $self = shift;

    my %links = map { ($_->embed_identifier => $_) } $self->all;

    return \%links;
}

# TODO Viewing an article will call both by_identifier
# and list_links.  Therefore two queries. If the blog
# gets remotely busy, sort this out, do a single query
# for both views.  NB Making this a single query is
# much easier as issue #294 is addressed.
#
# This method returns a resultset
sub links_list {
    my $self = shift;

    return $self->in_list->by_priority;
}


__PACKAGE__->meta->make_immutable;
1;

=encoding utf8

=head1 NAME

SongsToTheSiren::Schema::ResultSet::Link : ResultSet subclass for links

=head1 SYNOPSIS

    $song->links->by_priority-> ...;

=head1 DESCRIPTION

ResultSet methods for Links

=head1 METHODS

=over

=item list_links

Returns a resultset that includes only embedded links,
ie with a non-zero list_priority.

=item by_priority

A simple helper, for readability, to order
links by priority. Low number = high priority,
so sort is 'ascending'.

=item embedded_links

Returns a resultset that includes only embedded links,
ie with a non-empty embed_identifier string.

=item in_list

Returns a resultset that includes only link-list links,
ie with a non-zero list_priority value.

=item by_identifier

Returns the links in the current result set as
a hash, keyed by link identifier. Values are result
objects.

So, this will return an HASHREF of records,
keyed by identifier. So this only makes sense if the
resultset is already constrainted by song_id.

e.g. $song->by_identifier;

=item links_list 

Returns the ordered list of links for the list at the
end of an article. A shortcut for

 $rs->in_list->by_priority

=back

=head1 AUTHOR

David Stevenson david@ytfc.com

=cut

