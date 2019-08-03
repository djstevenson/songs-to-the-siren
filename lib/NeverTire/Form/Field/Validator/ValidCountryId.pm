package NeverTire::Form::Field::Validator::ValidCountryId;
use namespace::autoclean;
use Moose;

extends 'NeverTire::Form::Field::Validator::Base';
with 'NeverTire::Form::Field::Validator::Role';

sub validate{
	my ($self, $value) = @_;

	my $countries_rs = $self->schema->resultset('Country');
	my $found = $countries_rs->find($value);
	
    return undef if $found;
	return qq{Country id ${value} does not exist};
}


__PACKAGE__->meta->make_immutable;
1;
