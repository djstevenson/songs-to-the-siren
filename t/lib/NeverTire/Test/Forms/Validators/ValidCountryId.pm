package NeverTire::Test::Forms::Validators::ValidCountryId;
use Moose;
use namespace::autoclean;

use utf8;

use Test::More;
use Test::Exception;

extends 'NeverTire::Test::Base';
with 'NeverTire::Test::Role';

has '+user_base' => (default => 'form_val_8');

use NeverTire::Form::Field::Validator::ValidCountryId;

sub run {
	my $self = shift;
	
	# Create two country codes
	my $c1 = $self->create_country('XX');
	my $c2 = $self->create_country('YY');

	my $next_id = $c2->id + 1;
	
	my $tests = [
		{ data => 0,                expected => q{Country id 0 does not exist} },
		{ data => $c1->id,          expected => undef },
		{ data => $c2->id,          expected => undef },
		{ data => $next_id,         expected => qq{Country id ${next_id} does not exist} },
	];

	my $validator = NeverTire::Form::Field::Validator::ValidCountryId->new(schema => $self->schema);
	foreach my $test (@$tests){
		my $actual = $validator->validate($test->{data});
		my $expected = $test->{expected};
		if (defined $expected) {
			is($actual, $expected, 'ValidCountryId on "' . ($test->{data} // 'undef') . '" should return "' . $expected . '"');
		}
		else {
			ok(!defined($actual), 'ValidCountryId on "' . ($test->{data} // 'undef') . '" should return undef');
		}
	}
    
    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
