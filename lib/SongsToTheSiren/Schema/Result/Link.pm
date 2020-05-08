package SongsToTheSiren::Schema::Result::Link;
use Moose;
use namespace::autoclean;

extends 'SongsToTheSiren::Schema::Base::Result';

# TODO POD

use SongsToTheSiren::Model::Comment::Forest qw/ make_forest /;

__PACKAGE__->load_components('InflateColumn::DateTime');

__PACKAGE__->table('links');

__PACKAGE__->add_columns(
    id                => {data_type => 'INTEGER'},
    song_id           => {data_type => 'INTEGER'},

    # Embedded link stuff. Igored if embed_identifier is ''
    embed_identifier  => {data_type => 'TEXT'},
    embed_class       => {data_type => 'TEXT'},
    embed_description => {data_type => 'TEXT'},
    embed_url         => {data_type => 'TEXT'},

    # Priority determines the order the links appear in the list
    # at the end of a song article.  In ascending priority.
    # 0 = don't put link in the list - in which case the rest of
    # the link_* values are ignored
    list_description  => {data_type => 'TEXT'},
    list_url          => {data_type => 'TEXT'},
    list_priority     => {data_type => 'INTEGER'},
    list_css          => {data_type => 'TEXT'},
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to( song => 'SongsToTheSiren::Schema::Result::Song', { 'foreign.id' => 'self.song_id'  } );

no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;
