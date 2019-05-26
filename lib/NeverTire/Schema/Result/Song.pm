package NeverTire::Schema::Result::Song;
use Moose;
use namespace::autoclean;

extends 'NeverTire::Schema::Base::Result';

# TODO POD

use DateTime;

__PACKAGE__->load_components('InflateColumn::DateTime');

__PACKAGE__->table('songs');

__PACKAGE__->add_columns(
    id               => {data_type => 'INTEGER'},
    artist           => {data_type => 'TEXT'},
    title            => {data_type => 'TEXT'},
    album            => {data_type => 'TEXT'},

    summary_markdown => {data_type => 'TEXT'},
    summary_html     => {data_type => 'TEXT'},
    full_markdown    => {data_type => 'TEXT'},
    full_html        => {data_type => 'TEXT'},

    author_id        => {data_type => 'INTEGER'},

    date_created     => {data_type => 'DATETIME'},
    date_updated     => {data_type => 'DATETIME'},
    date_published   => {data_type => 'DATETIME'},

    # TEXT so it can be free-format, e.g. "summer 1991"
    date_released  => {data_type => 'TEXT'},
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(author => 'NeverTire::Schema::Result::User',   { 'foreign.id' => 'self.author_id' });

__PACKAGE__->has_many( song_tags => 'NeverTire::Schema::Result::SongTag', { 'foreign.song_id' => 'self.id' });

__PACKAGE__->many_to_many( tags => song_tags => 'tag');

sub show {
    my $self = shift;

    $self->update({ date_published => DateTime->now });
}

sub hide {
    my $self = shift;

    $self->update({ date_published => undef });
}

no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;
