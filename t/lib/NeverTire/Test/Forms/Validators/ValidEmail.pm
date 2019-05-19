package NeverTire::Test::Forms::Validators::ValidEmail;
use Moose;
use namespace::autoclean;

use utf8;

use Test::More;
use Test::Exception;

extends 'NeverTire::Test::Base';
with 'NeverTire::Test::Role';

has '+user_base' => (default => 'form_val_4');

use NeverTire::Form::Field::Validator::ValidEmail;

sub run {
	my $self = shift;
	
	my $tests = [
		# Don't test blank data, it should already be validated
		{ data => 'hoagy@example',          expected => 'Invalid email address' },
		{ data => 'x@x',                    expected => 'Invalid email address' },
		{ data => 'x@x.x',                  expected => undef                   },
		{ data => 'hoagyadmin@example.com', expected => undef                   },
		{ data => 'blahblahblah',           expected => 'Invalid email address' },
		{ data => 'blahblahblah.',          expected => 'Invalid email address' },
		{ data => 'blahblah.com',           expected => 'Invalid email address' },
		{ data => 'x@.example.com',         expected => 'Invalid email address' },
		{ data => 'x@example.com',          expected => undef                   },
		{ data => 'charlie.smith@bl.uk',    expected => undef                   },
	];

	my $validator = NeverTire::Form::Field::Validator::ValidEmail->new(schema => $self->schema);
	foreach my $test (@$tests){
		my $actual = $validator->validate($test->{data});
		my $expected = $test->{expected};
		if (defined $expected) {
			is($actual, $expected, 'ValidEmail on "' . ($test->{data} // 'undef') . '" should return "' . $expected . '"');
		}
		else {
			ok(!defined($actual), 'ValidEmail on "' . ($test->{data} // 'undef') . '" should return undef');
		}
	}
    
    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
