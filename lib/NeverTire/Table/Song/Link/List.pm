package NeverTire::Table::Song::Link::List;
use Moose;
use namespace::autoclean;

use NeverTire::Table::Moose;
extends 'NeverTire::Table::Base';

use DateTime;

sub _build_resultset {
    my $self = shift;

    return $self->c->stash->{song}
        ->links
        ->by_priority;
}

has_column id => (
    sortable     => 1,
    is_header    => 1,
    header       => 'ID',
);

has_column priority => (
    sortable     => 1,
);

has_column name => (
    sortable     => 1,
);

has_column url => (
    sortable     => 1,
);

has_column extras => (
    sortable     => 1,
);

has_column edit => (
    content => sub {
        my ($col, $table, $row) = @_;

        # my $url = $table->c->url_for('admin_edit_song_tags', song_id => $row->id);
        my $url = 'TODO';
        return qq{
            <a href="${url}">Edit</a>
        };
    },
);

has_column delete => (
    content => sub {
        my ($col, $table, $row) = @_;

        # my $url = $table->c->url_for('admin_edit_song_tags', song_id => $row->id);
        my $url = 'TODO';
        return qq{
            <a href="${url}">Delete</a>
        };
    },
);
has '+empty_text' => (default => 'No links for this song');

has '+default_order_by'   => (default => 'priority');

__PACKAGE__->meta->make_immutable;
1;
