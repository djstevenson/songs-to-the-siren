package NeverTire::Form::Field::Validator::Role;
use Moose::Role;

# my $error = $validator->validate($this_value);
# undef = no error
requires 'validate';

no Moose::Role;
1;
