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

has_column title => (
    sortable    => 1,
);

has_column artist_name => (
    header       => 'Artist',
    sortable     => 1,
    sort_by      => 'artist_name',
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
        if ( defined($pub) && DateTime->compare($pub, $now) < 1 ) {
            return 'Hide';
        }
        else {
            return 'Show';
        }
    },

);

has '+empty_text' => (default => 'No songs are in the datbase');

has '+default_order_by'   => (default => 'date_published');

__PACKAGE__->meta->make_immutable;
1;
