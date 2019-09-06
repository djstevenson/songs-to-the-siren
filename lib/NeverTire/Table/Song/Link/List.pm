package NeverTire::Table::Song::Link::List;
use Moose;
use namespace::autoclean;

use NeverTire::Table::Moose;
extends 'NeverTire::Table::Base';

use DateTime;

has song => (
    is          => 'ro',
    isa         => 'NeverTire::Schema::Result::Song',
    required    => 1,
);

sub _build_resultset {
    my $self = shift;

    return $self->song
        ->links
        ->by_priority;
}

has_column id => (
    header       => 'ID',
);

has_column priority => ();

has_column name => ();

has_column url => ();

has_column extras => ();

has_column edit => (
    content => sub {
        my ($col, $table, $row) = @_;

        my $url = $table->c->url_for('edit_song_link',
            song_id => $table->song->id,
            link_id => $row->id,
        );
        return qq{
            <a href="${url}">Edit</a>
        };
    },
);

has_column delete => (
    content => sub {
        my ($col, $table, $row) = @_;

        my $url = $table->c->url_for('delete_song_link',
            song_id => $table->song->id,
            link_id => $row->id,
        );
        return qq{
            <a href="${url}">Delete</a>
        };
    },
);
has '+empty_text' => (default => 'No links for this song');

__PACKAGE__->meta->make_immutable;
1;
