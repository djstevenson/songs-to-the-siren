package NeverTire::Test::Forms::Validators::UniqueEmail;
use Moose;
use namespace::autoclean;

use utf8;

use Test::More;
use Test::Exception;

extends 'NeverTire::Test::Base';
with 'NeverTire::Test::Role';

has '+user_base' => (default => 'form_val_6');

use NeverTire::Form::Field::Validator::UniqueEmail;

sub run {
	my $self = shift;
	
	# Two registered users, one non-registered
	my $user_data1 = $self->get_user_data;
	my $user_obj1  = $self->create_user($user_data1);
	my $user_data2 = $self->get_user_data;
	my $user_obj2  = $self->create_user($user_data2);
	my $user_data3 = $self->get_user_data;

	my $email1 = $user_data1->{email};
	my $email2 = $user_data2->{email};
	my $email3 = $user_data3->{email};
	
	my $tests = [
		{ data => $email1,          expected => 'Email already registered' },
		{ data => $email2,          expected => 'Email already registered' },
		{ data => $email3,          expected => undef,                     },
		{ data => uc($email1),      expected => 'Email already registered' },
		{ data => uc($email2),      expected => 'Email already registered' },
		{ data => uc($email3),      expected => undef,                     },
		{ data => lc($email1),      expected => 'Email already registered' },
		{ data => lc($email2),      expected => 'Email already registered' },
		{ data => lc($email3),      expected => undef,                     },
		{ data => ucfirst($email1), expected => 'Email already registered' },
		{ data => ucfirst($email2), expected => 'Email already registered' },
		{ data => ucfirst($email3), expected => undef,                     },
		{ data => 'x' . $email1,    expected => undef,                     },
		{ data => 'x' . $email2,    expected => undef,                     },
		{ data => 'x' . $email3,    expected => undef,                     },
	];

	my $validator = NeverTire::Form::Field::Validator::UniqueEmail->new(schema => $self->schema);
	foreach my $test (@$tests){
		my $actual = $validator->validate($test->{data});
		my $expected = $test->{expected};
		if (defined $expected) {
			is($actual, $expected, 'UniqueEmail on "' . ($test->{data} // 'undef') . '" should return "' . $expected . '"');
		}
		else {
			ok(!defined($actual), 'UniqueEmail on "' . ($test->{data} // 'undef') . '" should return undef');
		}
	}
    
    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
