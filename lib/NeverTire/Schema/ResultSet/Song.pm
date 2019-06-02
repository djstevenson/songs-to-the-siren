package NeverTire::Schema::ResultSet::Song;
use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';

# POD docs at end of this source file

use Carp qw/ croak /;

use DateTime;

sub home_page_songs {
    my ($self, $tag_id) = @_;

    return $self->select_metadata
        ->select_text(summary => 'html')
        ->where_has_tag($tag_id)
        ->where_published
        ->by_pubdate;
}

sub select_metadata {
    my $self = shift;

    return $self->search(undef, {
        select    => [qw/ id title album date_created date_updated date_published date_released author.name artist /],
        as        => [qw/ id title album date_created date_updated date_published date_released author_name artist /],
        join      => 'author',
    });
}

sub select_text {
    my ($self, $version, $format) = @_;

    croak 'Bad text version request'
        unless $version eq 'summary' || $version eq 'full';
    croak 'Bad text format request'
        unless $format eq 'html' || $format eq 'markdown';

    my $field = $version . '_' . $format;
    return $self->search(undef, {
        '+select' => [ $field ],
        '+as'     => [ $field ],
    });
}

sub where_published {
    my $self = shift;

    return $self->search({
        date_published => \' <= NOW()'
    });
}

sub where_has_tag {
    my ($self, $tag_id) = @_;

    return $self unless defined $tag_id;

    my $tag_sql = '(SELECT 1 FROM song_tags ST WHERE ST.tag_id=? AND ST.song_id=me.id)';
    return $self->search({
        '-exists' => \[$tag_sql, $tag_id]
    });
}

sub by_pubdate {
    my ($self, $order) = @_;

    $order //= '-desc';

    # Make some plain SQL so we can do NULLS FIRST
    # We won't see the NULL (unpublished) cases if
    # where_published() was called. But it's not
    # called when listing songs for admin user, so
    # we want the unpublished ones at the top.
    my $sql_order = $order eq '-desc' ? 'DESC' : 'ASC';
    return $self->search(undef, {
        order_by => \" date_published ${sql_order} NULLS FIRST",
    });
}

__PACKAGE__->meta->make_immutable;
1;

=pod

=head1 NAME

NeverTire::Schema::ResultSet::Song : ResultSet subclass for songs

=head1 SYNOPSIS

    my $rs = $schema->resultset('Song');
    $rs->search({})->select_metadata-> ...;

=head1 DESCRIPTION

ResultSet methods for Songs

=head1 METHODS

=over

=item home_page_songs

Shortcut for getting all the songs you want to list on the 
home page. Returns a result set.

Optional arg: tag_id, restricts the songs to ones that have
that tag.

  $song_rs->home_page_songs($tag_id);

Leave out $tag_id, or pass undef, to search for all songs
regardless of tags.

Usage:

  $song_rs->select_metadata

=item select_metadata

Indicates that we want to fetch the metadata (basically 
everything except the markdown and HTML), and does a join
to the users table to get the author name, which you can
access via via, e.g.:

  $song->get_column('author_name');

Usage:

  $song_rs->select_metadata

=item select_text($version, $format)

Indicates that we want to fetch the some form of the
description of the song. $version will be 'full' or
'summary', and $format will be 'html' or 'markdown.

  $song_rs->select_text(summary => 'html')

In this example, the result is available as:

  $result->summary_html;

These fields can be big so are not selected by default.

=item where_has_tag

Adds a WHERE clause to select only songs that have a
specified tag. Pass in a tag_id (or undef for no
filtering).
  
  $song_rs->where_has_tag(4);

=item where_published

Adds a WHERE clause to select only published songs.
  
  $song_rs->where_published;

=item by_pubdate

Sorts the resultset by publication date, newest first. 
Pass '-asc' as the arg if you want oldest first.

 $song_rs->by_pubdate;          # Sort desc
 $song_rs->by_pubdate('-asc');  # Sort asc

=back

=head1 AUTHOR

David Stevenson david@ytfc.com

=cut

