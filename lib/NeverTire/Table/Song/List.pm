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

has_column date_created => (
    header       => 'Created',
    sortable     => 1,
);

# TODO css to highlight whether it's in the future/past?
has_column date_published => (
    header       => 'Published',
    sortable     => 1,
);

has_column edit => (
    content => sub {
        my ($col, $table, $row) = @_;

        my $url = $table->c->url_for('edit_song', song_id => $row->id);
        return qq{
            <a href="${url}">Edit</a>
        };
    },

);

has_column publish => (
    content => sub {
        my ($col, $table, $row) = @_;

        my $pub = $row->date_published;
        my $now = DateTime->now;
        if ( defined($pub) && DateTime->compare($pub, $now) <= 0 ) {
            my $url = $table->c->url_for('hide_song', song_id => $row->id);
            return qq{
                <a href="${url}">Hide</a>
            };
        }
        else {
            my $url = $table->c->url_for('show_song', song_id => $row->id);
            return qq{
                <a href="${url}">Show</a>
            };
        }
    },

);

has '+empty_text' => (default => 'No songs are in the datbase');

has '+default_order_by'   => (default => 'date_published');

override class_for_row_data => sub {
    my ($self, $row_data) = @_;

    return 'table-warning' 
        unless $row_data->date_published;
};

__PACKAGE__->meta->make_immutable;
1;