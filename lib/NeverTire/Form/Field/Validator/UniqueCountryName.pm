package NeverTire::Form::Field::Validator::UniqueCountryName;
use Moose;

extends 'NeverTire::Form::Field::Validator::Base';
with 'NeverTire::Form::Field::Validator::Role';

sub validate{
	my ($self, $value) = @_;

	my $country_rs = $self->schema->resultset('Country');
	my $found = $country_rs->find($value);
	
    return 'Country name already in use' if $found;
	return undef;
}


__PACKAGE__->meta->make_immutable;
1;
