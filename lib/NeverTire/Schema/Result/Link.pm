package NeverTire::Schema::Result::Link;
use Moose;
use namespace::autoclean;

extends 'NeverTire::Schema::Base::Result';

# TODO POD

use NeverTire::Model::Comment::Forest qw/ make_forest /;

__PACKAGE__->load_components('InflateColumn::DateTime');

__PACKAGE__->table('links');

__PACKAGE__->add_columns(
    id               => {data_type => 'INTEGER'},
    song_id          => {data_type => 'INTEGER'},
    name             => {data_type => 'TEXT'},
    description      => {data_type => 'TEXT'},
    url              => {data_type => 'TEXT'},
    priority         => {data_type => 'INTEGER'},

    # e.g. ratio ("16x9" etc) for the youtubes.
    extras           => {data_type => 'TEXT'},
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to( song => 'NeverTire::Schema::Result::Song', { 'foreign.id' => 'self.song_id'  } );

no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;
