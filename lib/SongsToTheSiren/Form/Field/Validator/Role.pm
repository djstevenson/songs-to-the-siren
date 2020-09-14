package SongsToTheSiren::Form::Field::Validator::Role;
use utf8;
use Moose::Role;

# my $error = $validator->validate($this_value);
# undef = no error
requires 'validate';

no Moose::Role;
1;
