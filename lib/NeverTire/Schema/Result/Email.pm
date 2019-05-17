package NeverTire::Schema::Result::Email;
use Moose;
use namespace::autoclean;

extends 'NeverTire::Schema::Base::Result';

use Mojo::JSON qw/ decode_json encode_json /;

# TODO POD

__PACKAGE__->load_components('InflateColumn::DateTime');

__PACKAGE__->table('emails');

__PACKAGE__->add_columns(
	id            => {data_type => 'INTEGER'},
	email_from    => {data_type => 'TEXT'},
	email_to      => {data_type => 'TEXT'},
	template_name => {data_type => 'TEXT'},
	data          => {data_type => 'TEXT'},     # JSON data for personalising email
	queued_at     => {data_type => 'DATETIME'},
	sent_at       => {data_type => 'DATETIME'}, # Null until email is sent
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->inflate_column(data => {
	inflate => sub{ decode_json(shift) }, 
	deflate	=> sub{ encode_json(shift) },
});

no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;

