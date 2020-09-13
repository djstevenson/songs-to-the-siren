package SongsToTheSiren::Form::Field::Validator::ValidInteger;
use namespace::autoclean;
use Moose;

extends 'SongsToTheSiren::Form::Field::Validator::Base';
with 'SongsToTheSiren::Form::Field::Validator::Role';


sub validate {
    my ($self, $value) = @_;

    return undef if $value =~ m{ \A [0-9]{1,} \Z }ix;

    return 'Invalid number';

}


__PACKAGE__->meta->make_immutable;
1;
