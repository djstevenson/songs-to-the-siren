package NeverTire::Table::Song::List;
use Moose;
use namespace::autoclean;

use NeverTire::Table::Moose;
extends 'NeverTire::Table::Base';

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

has_column date_published => (
    header       => 'Published',
    sortable     => 1,
);

has '+empty_text' => (default => 'No songs are in the datbase');

has '+default_order_by'   => (default => 'date_published');

__PACKAGE__->meta->make_immutable;
1;
