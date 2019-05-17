package NeverTire::Schema::Result::Song;
use Moose;
use namespace::autoclean;

extends 'NeverTire::Schema::Base::Result';

# TODO POD

__PACKAGE__->load_components('InflateColumn::DateTime');

__PACKAGE__->table('songs');

__PACKAGE__->add_columns(
    id             => {data_type => 'INTEGER'},
    artist_id      => {data_type => 'INTEGER'},
    title          => {data_type => 'TEXT'},
    album          => {data_type => 'TEXT'},

    markdown       => {data_type => 'TEXT'},
    html           => {data_type => 'TEXT'},

    author_id      => {data_type => 'INTEGER'},

    date_created   => {data_type => 'DATETIME'},
    date_modified  => {data_type => 'DATETIME'},
    date_published => {data_type => 'DATETIME'},

    # TEXT so it can be free-format, e.g. "summer 1991"
    date_released  => {data_type => 'TEXT'},
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(author => 'Forum::Schema::Result::User',   { 'foreign.id' => 'self.author_id' });
__PACKAGE__->belongs_to(artist => 'Forum::Schema::Result::Artist', { 'foreign.id' => 'self.artist_id' });

no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;
