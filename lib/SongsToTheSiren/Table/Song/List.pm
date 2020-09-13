package SongsToTheSiren::Table::Song::List;
use Moose;
use namespace::autoclean;

use SongsToTheSiren::Table::Moose;
extends 'SongsToTheSiren::Table::Base';

use DateTime;

sub _build_resultset {
    my $self = shift;

    my $rs = $self->c->schema->resultset('Song');
    return $rs->select_metadata->select_comment_count('unapproved')->by_id;
}

has_column id => (header => 'ID');

has_column title => (
    link => sub {
        my ($col, $table, $row) = @_;

        return $table->c->url_for('view_song', song_id => $row->id);
    },
);

has_column comment_count => (
    header  => 'Unapproved',
    content => sub {
        my ($col, $table, $row) = @_;

        return $row->get_column('comment_count');
    },
);

# TODO css to highlight whether it's in the future/past?
has_column published_at => ();

has_column publish => (
    content => sub {
        my ($col, $table, $row) = @_;

        if (defined $row->published_at) {
            my $url = $table->c->url_for('admin_unpublish_song', song_id => $row->id);
            return qq{<a href="${url}">Hide</a>};
        }
        else {
            my $url = $table->c->url_for('admin_publish_song', song_id => $row->id);
            return qq{<a href="${url}">Show</a>};
        }
    },

);

has_column tags => (
    content => sub {
        my ($col, $table, $row) = @_;

        my $url = $table->c->url_for('admin_edit_song_tags', song_id => $row->id);
        return qq{<a href="${url}">Tags</a>};
    },

);

has_column links => (
    content => sub {
        my ($col, $table, $row) = @_;

        my $url = $table->c->url_for('admin_list_song_links', song_id => $row->id);
        return qq{<a href="${url}">Links</a>};
    },

);

has_column edit => (
    content => sub {
        my ($col, $table, $row) = @_;

        my $url = $table->c->url_for('admin_edit_song', song_id => $row->id);
        return qq{<a href="${url}">Edit</a>};
    },

);

has_column delete => (
    content => sub {
        my ($col, $table, $row) = @_;

        my $url = $table->c->url_for('admin_delete_song', song_id => $row->id);
        return qq{<a href="${url}">Delete</a>};
    },

);

has '+empty_text' => (default => 'No songs yet defined');

override class_for_row_data => sub {
    my ($self, $row_data) = @_;

    return 'song-is-not-published' unless $row_data->published_at;

    return undef;
};

__PACKAGE__->meta->make_immutable;
1;
