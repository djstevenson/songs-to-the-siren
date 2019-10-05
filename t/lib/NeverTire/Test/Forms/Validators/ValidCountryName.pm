package NeverTire::Test::Forms::Validators::ValidCountryName;
use Moose;
use namespace::autoclean;

use utf8;

use Test::More;
use Test::Exception;

extends 'NeverTire::Test::Base';
with 'NeverTire::Test::Role';

has '+user_base' => (default => 'form_val_8');

use NeverTire::Form::Field::Validator::ValidCountryName;

sub run {
	my $self = shift;
	
	# Create two country codes
	my $c1 = $self->create_country('XX');
	my $c2 = $self->create_country('YY');

	my $tests = [
		{ data => 'XY',             expected => q{Country name XY does not exist} },
		{ data => $c1->name,        expected => undef },
		{ data => $c2->name,        expected => undef },
	];

	my $validator = NeverTire::Form::Field::Validator::ValidCountryName->new(schema => $self->schema);
	foreach my $test (@$tests){
		my $actual = $validator->validate($test->{data});
		my $expected = $test->{expected};
		if (defined $expected) {
			is($actual, $expected, 'ValidCountryName on "' . ($test->{data} // 'undef') . '" should return "' . $expected . '"');
		}
		else {
			ok(!defined($actual), 'ValidCountryName on "' . ($test->{data} // 'undef') . '" should return undef');
		}
	}
    
    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
