package SongsToTheSiren::Form::Field::Filter::Base;
use utf8;
use namespace::autoclean;
use Moose;

has schema => (is => 'ro', isa => 'SongsToTheSiren::Schema', required => 1);

1;
