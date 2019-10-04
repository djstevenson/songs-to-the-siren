package NeverTire::Test::Forms::Validators::UniqueCountryName;
use Moose;
use namespace::autoclean;

use utf8;

use Test::More;
use Test::Exception;

extends 'NeverTire::Test::Base';
with 'NeverTire::Test::Role';

has '+user_base' => (default => 'form_val_9');

use NeverTire::Form::Field::Validator::UniqueCountryName;

# Names here are case-sensitive, though in practice we'll only use upper-case
sub run {
	my $self = shift;

	# Create an admin user, who creates a country with name 'XY'.
	my $user_data1 = $self->get_user_data;
	my $user_obj1  = $self->create_admin_user($user_data1);
	$user_obj1->admin_create_country({name => 'XY', emoji => 'XXYY'});

	my $tests = [
		{ data => 'XY', expected => 'Country name already in use' },
		{ data => 'XX', expected => undef                 },
	];

	my $validator = NeverTire::Form::Field::Validator::UniqueCountryName->new(schema => $self->schema);
	foreach my $test (@$tests){
		my $actual = $validator->validate($test->{data});
		my $expected = $test->{expected};
		if (defined $expected) {
			is($actual, $expected, 'UniqueCountryName on "' . ($test->{data} // 'undef') . '" should return "' . $expected . '"');
		}
		else {
			ok(!defined($actual), 'UniqueCountryName on "' . ($test->{data} // 'undef') . '" should return undef');
		}
	}
    
    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
