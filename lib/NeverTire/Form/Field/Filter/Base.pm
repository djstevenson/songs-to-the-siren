package NeverTire::Form::Field::Filter::Base;
use namespace::autoclean;
use Moose;

has schema => (
	is			=> 'ro',
	isa			=> 'NeverTire::Schema',
	required    => 1,
);

1;
