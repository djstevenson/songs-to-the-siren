package SongsToTheSiren::Form::Field::Validator::Required;
use namespace::autoclean;
use Moose;

extends 'SongsToTheSiren::Form::Field::Validator::Base';
with 'SongsToTheSiren::Form::Field::Validator::Role';


sub validate {
    my ($self, $value) = @_;

    return "Required" unless length($value);
    return undef;
}


__PACKAGE__->meta->make_immutable;
1;
