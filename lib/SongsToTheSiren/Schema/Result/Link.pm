package SongsToTheSiren::Schema::Result::Link;
use Moose;
use namespace::autoclean;

extends 'SongsToTheSiren::Schema::Base::Result';

# TODO POD

use SongsToTheSiren::Model::Comment::Forest qw/ make_forest /;

__PACKAGE__->load_components('InflateColumn::DateTime');

__PACKAGE__->table('links');

__PACKAGE__->add_columns(
    id               => {data_type => 'INTEGER'},
    song_id          => {data_type => 'INTEGER'},
    identifier       => {data_type => 'TEXT'},
    class            => {data_type => 'TEXT'},   # Perl class of renderer
    description      => {data_type => 'TEXT'},
    url              => {data_type => 'TEXT'},

    # Priority determines the order the links appear in the list
    # at the end of a song article.  In ascending priority.
    # 0 = don't put link in the list.
    priority         => {data_type => 'INTEGER'},

    link_text        => {data_type => 'TEXT'},
    title            => {data_type => 'TEXT'},

    # JSON e.g. {"ratio": "16x9", "start": "01:10"} for the youtubes.
    extras           => {data_type => 'TEXT'},

    # CSS class for the <a> link in the list. NULL = none
    css              => {data_type => 'TEXT'},
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to( song => 'SongsToTheSiren::Schema::Result::Song', { 'foreign.id' => 'self.song_id'  } );

no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;
