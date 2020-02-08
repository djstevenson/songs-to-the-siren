package SongsToTheSiren::Schema::ResultSet::Tag;
use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';

# POD docs at end of this source file

use Carp qw/ croak /;

use DateTime;

sub search_by_ids {
    my ($self, $tag_ids) = @_;

    return [] unless $tag_ids;

    my @ids = split(/,\s*/, $tag_ids);
    return [] unless scalar @ids;


    return [
        $self->search({
            id => { -in => \@ids }
        })->all
    ];
}



__PACKAGE__->meta->make_immutable;
1;

=pod

=head1 NAME

SongsToTheSiren::Schema::ResultSet::Tag : ResultSet subclass for tags

=head1 SYNOPSIS

    my $rs = $schema->resultset('Tag');
    $rs->search_by_ids("1,4,99");

=head1 DESCRIPTION

ResultSet methods for Tags

=head1 METHODS

=over

=item search_by_ids

Takes an optional comma-separated list of tag ids.
If the argument is not supplied, or matches no
tags, we return an empty arrayref.

Otherwise, we return an arrayref of matchings tags.

Note: Normally, a resultset method would return a 
new resultset for chaining, but returning an
array(ref) works ok here.

=back

=head1 AUTHOR

David Stevenson david@ytfc.com

=cut

