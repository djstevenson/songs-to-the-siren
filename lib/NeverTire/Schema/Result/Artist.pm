package NeverTire::Schema::Result::Artist;
use Moose;
use namespace::autoclean;

extends 'NeverTire::Schema::Base::Result';

# TODO POD

__PACKAGE__->load_components('InflateColumn::DateTime');

__PACKAGE__->table('songs');

__PACKAGE__->add_columns(
    id             => {data_type => 'INTEGER'},
    date_created   => {data_type => 'DATETIME'},
    date_modified  => {data_type => 'DATETIME'},
);

__PACKAGE__->set_primary_key('id');

# Plan is not to add more than one song for an artist, but
# the DB should allow it if that's what we decide to do.
__PACKAGE__->has_many(has_many => 'NeverTire::Schema::Result::Song', { 'foreign.artist_id' => 'self.id' });

no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;
