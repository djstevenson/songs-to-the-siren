package NeverTire::Form::Field::Validator::ValidCountryName;
use namespace::autoclean;
use Moose;

extends 'NeverTire::Form::Field::Validator::Base';
with 'NeverTire::Form::Field::Validator::Role';

sub validate{
	my ($self, $value) = @_;

	my $countries_rs = $self->schema->resultset('Country');
	my $found = $countries_rs->find($value);
	
    return undef if $found;
	return qq{Country name ${value} does not exist};
}


__PACKAGE__->meta->make_immutable;
1;
