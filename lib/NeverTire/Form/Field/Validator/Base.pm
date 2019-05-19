package NeverTire::Form::Field::Validator::Base;
use namespace::autoclean;
use Moose;

#  TODO Consider using Mojolicious validations

has schema => (
	is			=> 'ro',
	isa			=> 'NeverTire::Schema',
	required    => 1,
);

1;
