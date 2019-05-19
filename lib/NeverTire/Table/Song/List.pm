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
    sortable    => 1,
);

has_column title => (
    sortable    => 1,
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

has_column action => (
    content => sub {
        my ($col, $table, $row) = @_;

        # TODO Do these as links when the editor is implemented
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

__PACKAGE__->meta->make_immutable;
1;
