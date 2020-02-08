package SongsToTheSiren::Form::Field::Validator::Base;
use namespace::autoclean;
use Moose;

#  TODO Consider using Mojolicious validations

has schema => (
	is			=> 'ro',
	isa			=> 'SongsToTheSiren::Schema',
	required    => 1,
);

1;
