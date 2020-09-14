package SongsToTheSiren::Schema::Result::Tag;
use utf8;
use Moose;
use namespace::autoclean;

extends 'SongsToTheSiren::Schema::Base::Result';

# TODO POD

__PACKAGE__->load_components('InflateColumn::DateTime');

__PACKAGE__->table('tags');

__PACKAGE__->add_columns(
    id         => {data_type => 'INTEGER', is_auto_increment => 1 },
    name       => {data_type => 'TEXT'},
    created_at => {data_type => 'DATETIME'},
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->has_many(song_tags => 'SongsToTheSiren::Schema::Result::SongTag', {'foreign.tag_id' => 'self.id'});

__PACKAGE__->many_to_many(songs => song_tags => 'songs');

no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;
