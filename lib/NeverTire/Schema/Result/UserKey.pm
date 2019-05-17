package Forum::Schema::Result::UserKey;
use Moose;
use namespace::autoclean;

extends 'NeverTire::Schema::Base::Result';

use DateTime;
use Forum::Util::Password;

# TODO POD

__PACKAGE__->load_components('InflateColumn::DateTime');

__PACKAGE__->table('user_keys');

__PACKAGE__->add_columns(
	user_id       => {data_type => 'INTEGER'},
	purpose       => {data_type => 'TEXT'},
	key_hash      => {data_type => 'TEXT'},   # Bcrypt 2a with random salt
	date_expires  => {data_type => 'DATETIME'},
);

__PACKAGE__->set_primary_key(qw/ user_id purpose /);

no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;
