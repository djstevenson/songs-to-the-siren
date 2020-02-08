package SongsToTheSiren::Schema::ResultSet::Song;
use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';

# POD docs at end of this source file

use Carp qw/ croak /;

use DateTime;

sub home_page_songs {
    my ($self, $tags) = @_;

    my $rs = $self->select_metadata
        ->select_text(summary => 'html')
        ->where_published
        ->by_publication_date;

    if ($tags) {
        foreach my $tag (@$tags) {
            $rs = $rs->where_has_tag($tag);
        }
    }

    return $rs;
}

sub full_song_data {
    my ($self, $song_id, $is_admin) = @_;

    # TODO Prefetch tags?
    my $rs =  $self
        ->select_metadata
        ->select_text(summary => 'markdown')
        ->select_text(full    => 'markdown')
        ->select_text(full    => 'html')
        ->select_comment_count('approved');
    
    $rs = $rs->where_published unless $is_admin;

    return $rs->find($song_id);
}

sub select_metadata {
    my $self = shift;

    return $self->search(undef, {
        select    => [qw/ id title album image country_id country.name country.emoji created_at updated_at published_at released_at author.name artist /],
        as        => [qw/ id title album image country_id country_name country_emoji created_at updated_at published_at released_at author_name artist /],
        join      => [qw/ author country /],
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

sub select_comment_count {
    my ($self, $approved_option) = @_;

    $approved_option //= 'all';

    my $sql_map = {
        approved   => 'AND C.approved_at IS NOT NULL',
        unapproved => 'AND C.approved_at IS NULL',
    };

    my $approved_sql = exists $sql_map->{$approved_option}
        ? $sql_map->{$approved_option}
        : '';

    my $sql = qq{ (SELECT COUNT(*) FROM comments C WHERE C.song_id=me.id ${approved_sql}) AS comment_count };

    return $self->search(undef, {
        '+select' => [ \$sql ],
        '+as'     => [ 'comment_count' ],
    });
}

sub where_published {
    my $self = shift;

    return $self->search({
        published_at => \' <= NOW()'
    });
}

sub where_has_tag {
    my ($self, $tag) = @_;

    my $tag_sql = '(SELECT 1 FROM song_tags ST WHERE ST.tag_id=? AND ST.song_id=me.id)';

    return $self->search({
        '-exists' => \[$tag_sql, $tag->id]
    });
}

sub by_id {
    my ($self, $order) = @_;

    $order //= '-desc';

    return $self->search(undef, {
        order_by => { $order => 'id' }
    });
}

sub by_publication_date {
     my ($self, $order) = @_;

     $order //= '-desc';

    # Make some plain SQL so we can do NULLS FIRST
    # We won't see the NULL (unpublished) cases if
    # where_published() was called. But it's not
    # called when listing songs for admin user, so
    # we want the unpublished ones at the top.
    # Secondary sort is by id in the same order
    my $sql_order = $order eq '-desc' ? 'DESC' : 'ASC';
    return $self->search(undef, {
        order_by => \" published_at ${sql_order} NULLS FIRST, id ${sql_order}",
    });
}

sub newer {
    my ($self, $song) = @_;

    return $self->search({
        id => { '>' => $song->id }
    }, {
        order_by => { -asc => 'id' },
        rows     => 1,
    });
}

sub older {
    my ($self, $song) = @_;

    return $self->search({
        id => { '<' => $song->id }
    }, {
        order_by => { -desc => 'id' },
        rows     => 1,
    });
}

__PACKAGE__->meta->make_immutable;
1;

=pod

=head1 NAME

SongsToTheSiren::Schema::ResultSet::Song : ResultSet subclass for songs

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

Optional arg: tags, a reference to an array of Tag
result objects. Restricts the songs to ones that have
one or more of these tags.

    $song_rs->home_page_songs($tags);

Leave out $tags, or pass undef, to search for all songs
regardless of tags.

Usage:

    $song_rs->select_metadata

=item select_metadata

Indicates that we want to fetch the metadata (basically 
everything except the markdown and HTML), and does a join
to the users table to get the author name, which you can
access via, e.g.:

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

=item select_comment_count

Gets the count of comments for this song:

    $song_rs->select_comment_count($option);

The result is available as:

    $result->get_column('comment_count');

If $option is 'approved', only approved comments are
counted. If it is 'unapproved', then only unapproved
comments are counted. Otherwise, all are counted.

=item where_has_tag

Adds a WHERE clause to select only songs that have the
specified tag. Pass in a Tag result object.
  
    $song_rs->where_has_tag($tag_object);

=item where_published

Adds a WHERE clause to select only published songs.
  
    $song_rs->where_published;

=item by_id

Sorts the resultset by id, descending (newest first).

Pass '-asc' as the arg if you want oldest first.

    $song_rs->by_id;          # Sort desc
    $song_rs->by_id('-asc');  # Sort asc

=item by_publication_date

Sorts the resultset by publication date, newest first

Pass '-asc' as the arg if you want oldest first.

    $song_rs->by_publication_date;          # Sort desc
    $song_rs->by_publication_date('-asc');  # Sort asc

=item newer

Finds the songs newer than the specified song.

Normally, you'll call this like:

   $rs->newer($song)->where_published->single

There is a short-cut via the song result object which
does the exact above sequence, call this as:

  $song->newer;

=item older

Finds the songs older than the specified song.

Normally, you'll call this like:

   $rs->older($song)->where_published->single

There is a short-cut via the song result object which
does the exact above sequence, call this as:

  $song->older;

=back

=head1 AUTHOR

David Stevenson david@ytfc.com

=cut

