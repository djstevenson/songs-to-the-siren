package NeverTire::Table::Song::List;
use Moose;
use namespace::autoclean;

use NeverTire::Table::Moose;
extends 'NeverTire::Table::Base';

use DateTime;

sub _build_resultset {
    my $self = shift;

    return $self->c->schema
        ->resultset('Song')
        ->select_metadata
        ->by_pubdate;
}

has_column id => (
    sortable     => 1,
    is_header    => 1,
    header       => 'ID',
);

has_column title => (
    sortable     => 1,
);

has_column artist => (
    sortable     => 1,
);

has_column created_at => (
    header       => 'Created',
    sortable     => 1,
);

# TODO css to highlight whether it's in the future/past?
has_column published_at => (
    header       => 'Published',
    sortable     => 1,
);

has_column tags => (
    content => sub {
        my ($col, $table, $row) = @_;

        my $url = $table->c->url_for('admin_edit_song_tags', song_id => $row->id);
        return qq{
            <a href="${url}">Tags</a>
        };
    },

);

has_column edit => (
    content => sub {
        my ($col, $table, $row) = @_;

        my $url = $table->c->url_for('admin_edit_song', song_id => $row->id);
        return qq{
            <a href="${url}">Edit</a>
        };
    },

);

has_column publish => (
    content => sub {
        my ($col, $table, $row) = @_;

        my $pub = $row->published_at;
        my $now = DateTime->now;
        if ( defined($pub) && DateTime->compare($pub, $now) <= 0 ) {
            my $url = $table->c->url_for('admin_hide_song', song_id => $row->id);
            return qq{
                <a href="${url}">Hide</a>
            };
        }
        else {
            my $url = $table->c->url_for('admin_show_song', song_id => $row->id);
            return qq{
                <a href="${url}">Show</a>
            };
        }
    },

);

has_column delete => (
    content => sub {
        my ($col, $table, $row) = @_;

        my $url = $table->c->url_for('admin_delete_song', song_id => $row->id);
        return qq{
            <a href="${url}">Delete</a>
        };
    },

);

has '+empty_text' => (default => 'No songs are in the datbase');

has '+default_order_by'   => (default => 'published_at');

override class_for_row_data => sub {
    my ($self, $row_data) = @_;

    return 'table-warning' 
        unless $row_data->published_at;
};

__PACKAGE__->meta->make_immutable;
1;
