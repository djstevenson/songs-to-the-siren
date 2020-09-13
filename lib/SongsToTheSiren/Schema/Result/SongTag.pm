package SongsToTheSiren::Schema::Result::SongTag;
use Moose;
use namespace::autoclean;

extends 'SongsToTheSiren::Schema::Base::Result';

# TODO POD

__PACKAGE__->load_components('InflateColumn::DateTime');

__PACKAGE__->table('song_tags');

__PACKAGE__->add_columns(tag_id => {data_type => 'INTEGER'}, song_id => {data_type => 'INTEGER'});

__PACKAGE__->set_primary_key(qw/ tag_id song_id /);

__PACKAGE__->belongs_to(songs => 'SongsToTheSiren::Schema::Result::Song', {'foreign.id' => 'self.song_id'});
__PACKAGE__->belongs_to(tags  => 'SongsToTheSiren::Schema::Result::Tag',  {'foreign.id' => 'self.tag_id'});

no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;
