package NeverTire::Schema::Result::User;
use Moose;
use namespace::autoclean;

extends 'NeverTire::Schema::Base::Result';

# TODO POD

__PACKAGE__->load_components('InflateColumn::DateTime');

__PACKAGE__->table('users');

__PACKAGE__->add_columns(
    id            => {data_type => 'INTEGER'},
    name          => {data_type => 'TEXT'},
    email         => {data_type => 'TEXT'},
    password_hash => {data_type => 'TEXT'},   # Bcrypt 2a with random salt
    date_created  => {data_type => 'DATETIME'},
    date_password => {data_type => 'DATETIME'},
);

__PACKAGE__->set_primary_key('id');

# Relation for the song descriptions created by this user.
__PACKAGE__->has_many(has_many => 'NeverTire::Schema::Result::Song', { 'foreign.author_id' => 'self.id' });

no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;
