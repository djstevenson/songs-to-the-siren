package SongsToTheSiren::Form::Field::Validator::Base;
use utf8;
use Moose;
use namespace::autoclean;

#  TODO Consider using Mojolicious validations

has schema => (is => 'ro', isa => 'SongsToTheSiren::Schema', required => 1);

1;
