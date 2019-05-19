package NeverTire::Schema::ResultSet::Song;
use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';

# POD docs at end of this source file


use DateTime;

sub home_page_songs {
    my $self = shift;

    return $self->select_metadata
        ->select_html
        ->where_published
        ->by_pubdate;
}

sub select_metadata {
    my $self = shift;

    return $self->search(undef, {
        select    => [qw/ id title album date_created date_updated date_published author.name artist.name /],
        as        => [qw/ id title album date_created date_updated date_published author_name artist_name /],
        join      => [qw/ author artist /],
    });
}

sub select_markdown {
    my $self = shift;

    return $self->search(undef, {
        '+select' => [qw/ markdown /],
        '+as'     => [qw/ markdown /],
    });
}

sub select_html {
    my $self = shift;

    return $self->search(undef, {
        '+select' => [qw/ html /],
        '+as'     => [qw/ html /],
    });
}

sub where_published {
    my $self = shift;

    return $self->search({
        date_published => \' <= NOW()'
    });}

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

=item select_metadata

Indicates that we want to fetch the metadata (basically 
everything except the markdown and HTML), and does a join
to other tables to get author_name and artist_name, which
you can get via, e.g.:

  $song->get_column('author_name');

Usage:

  $song_rs->select_metadata

=item select_markdown

Indicates that we want to fetch the markdown, which you'll
want to do when editing a song.

  $song_rs->select_markdown

It can be a big field so it's not selected by default.

=item select_html

Indicates that we want to fetch the rendered html, which you'll
want to do when displaying a song.

  $song_rs->select_html

It can be a big field so it's not selected by default.

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

