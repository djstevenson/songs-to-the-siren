package NeverTire::Form::Field::Validator::Required;
use namespace::autoclean;
use Moose;

extends 'NeverTire::Form::Field::Validator::Base';
with 'NeverTire::Form::Field::Validator::Role';

 
sub validate{
	my ($self, $value) = @_;

    return "Required" unless length($value);
	return undef;
}


__PACKAGE__->meta->make_immutable;
1;
