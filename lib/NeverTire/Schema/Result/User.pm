package NeverTire::Schema::Result::User;
use Moose;
use namespace::autoclean;

extends 'NeverTire::Schema::Base::Result';

# TODO POD

# Bring in methods that we split out. We did that to keep
# file sizes more managable, and to group related methods
with 'NeverTire::Schema::Role::User::Auth';
with 'NeverTire::Schema::Role::User::Song';
with 'NeverTire::Schema::Role::User::Content';
with 'NeverTire::Schema::Role::User::Comment';

__PACKAGE__->load_components('InflateColumn::DateTime');

__PACKAGE__->table('users');

__PACKAGE__->add_columns(
    id            => {data_type => 'INTEGER'},
    name          => {data_type => 'TEXT'},
    email         => {data_type => 'TEXT'},
    password_hash => {data_type => 'TEXT'},   # Bcrypt 2a with random salt
    admin         => {data_type => 'BOOLEAN'},
    registered_at => {data_type => 'DATETIME'},
    confirmed_at  => {data_type => 'DATETIME'},
    password_at   => {data_type => 'DATETIME'},
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->has_many(content  => 'NeverTire::Schema::Result::Content', { 'foreign.author_id' => 'self.id' });
__PACKAGE__->has_many(songs    => 'NeverTire::Schema::Result::Song',    { 'foreign.author_id' => 'self.id' });
__PACKAGE__->has_many(comments => 'NeverTire::Schema::Result::Comment', { 'foreign.author_id' => 'self.id' });


no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;
