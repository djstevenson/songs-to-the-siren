package NeverTire::Test::Forms::Validators::UniqueName;
use Moose;
use namespace::autoclean;

use utf8;

use Test::More;
use Test::Exception;

extends 'NeverTire::Test::Base';
with 'NeverTire::Test::Role';

has '+user_base' => (default => 'form_val_5');

use NeverTire::Form::Field::Validator::UniqueName;

sub run {
	my $self = shift;

	# Two registered users, one non-registered
	my $user_data1 = $self->get_user_data;
	my $user_obj1  = $self->create_user($user_data1);
	my $user_data2 = $self->get_user_data;
	my $user_obj2  = $self->create_user($user_data2);
	my $user_data3 = $self->get_user_data;

	my $name1 = $user_data1->{name};
	my $name2 = $user_data2->{name};	
	my $name3 = $user_data3->{name};
	
	my $tests = [
		# Don't test blank data, it should already be validated
		{ data => $name1,          expected => 'Name already in use' },
		{ data => $name2,          expected => 'Name already in use' },
		{ data => lc($name1),      expected => 'Name already in use' },
		{ data => uc($name1),      expected => 'Name already in use' },
		{ data => uc($name2),      expected => 'Name already in use' },
		{ data => ucfirst($name2), expected => 'Name already in use' },
		{ data => $name3,          expected => undef,                },
		{ data => uc($name3),      expected => undef,                },
		{ data => $name3 . '_',    expected => undef,                },
		{ data => 'xyzzy',         expected => undef,                },
	];

	my $validator = NeverTire::Form::Field::Validator::UniqueName->new(schema => $self->schema);
	foreach my $test (@$tests){
		my $actual = $validator->validate($test->{data});
		my $expected = $test->{expected};
		if (defined $expected) {
			is($actual, $expected, 'UniqueName on "' . ($test->{data} // 'undef') . '" should return "' . $expected . '"');
		}
		else {
			ok(!defined($actual), 'UniqueName on "' . ($test->{data} // 'undef') . '" should return undef');
		}
	}
    
    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
