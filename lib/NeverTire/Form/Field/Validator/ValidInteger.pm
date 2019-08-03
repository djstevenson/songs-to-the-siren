package NeverTire::Form::Field::Validator::ValidInteger;
use namespace::autoclean;
use Moose;

extends 'NeverTire::Form::Field::Validator::Base';
with 'NeverTire::Form::Field::Validator::Role';


sub validate{
	my ($self, $value) = @_;

    return undef if $value =~ m{^[0-9]{1,}$}i;

    return 'Invalid number';

}


__PACKAGE__->meta->make_immutable;
1;
