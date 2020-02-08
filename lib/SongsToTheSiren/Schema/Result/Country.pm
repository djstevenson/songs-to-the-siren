package SongsToTheSiren::Schema::Result::Country;
use Moose;
use namespace::autoclean;

extends 'SongsToTheSiren::Schema::Base::Result';

# TODO POD

__PACKAGE__->table('countries');

__PACKAGE__->add_columns(
    id               => {data_type => 'INTEGER'},
    name             => {data_type => 'TEXT'},
    emoji            => {data_type => 'TEXT'},
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->has_many( songs => 'SongsToTheSiren::Schema::Result::Song', { 'foreign.country_id' => 'self.id' });

no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;
