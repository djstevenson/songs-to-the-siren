package SongsToTheSiren::Table::Song::Link::List;
use Moose;
use namespace::autoclean;

use SongsToTheSiren::Table::Moose;
extends 'SongsToTheSiren::Table::Base';

use DateTime;

has song => (
    is          => 'ro',
    isa         => 'SongsToTheSiren::Schema::Result::Song',
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

has_column identifier => ();

has_column description => ();

has_column edit => (
    content => sub {
        my ($col, $table, $row) = @_;

        my $url = $table->c->url_for('admin_edit_song_link',
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

        my $url = $table->c->url_for('admin_delete_song_link',
            song_id => $table->song->id,
            link_id => $row->id,
        );
        return qq{
            <a href="${url}">Delete</a>
        };
    },
);

has_column copy => (
    content => sub {
        my ($col, $table, $row) = @_;

        my $url = $table->c->url_for('admin_copy_song_link',
            song_id => $table->song->id,
            link_id => $row->id,
        );
        return qq{
            <a href="${url}">Copy</a>
        };
    },
);

has '+empty_text' => (default => 'No links for this song');

__PACKAGE__->meta->make_immutable;
1;
