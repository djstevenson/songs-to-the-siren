package SongsToTheSiren::Schema::Result::UserKey;
use strict;
use warnings;
use utf8;

use base 'DBIx::Class::Core';

use DateTime;
use SongsToTheSiren::Util::Password;

# TODO POD

__PACKAGE__->load_components('InflateColumn::DateTime');

__PACKAGE__->table('user_keys');

__PACKAGE__->add_columns(
    user_id    => {data_type => 'INTEGER'},
    purpose    => {data_type => 'TEXT'},
    key_hash   => {data_type => 'TEXT'},       # Bcrypt 2a with random salt
    expires_at => {data_type => 'DATETIME'},
);

__PACKAGE__->set_primary_key(qw/ user_id purpose /);

1;
