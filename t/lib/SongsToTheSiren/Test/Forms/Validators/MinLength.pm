package SongsToTheSiren::Test::Forms::Validators::MinLength;
use Moose;
use namespace::autoclean;

use utf8;

use Test::More;
use Test::Exception;

extends 'SongsToTheSiren::Test::Base';
with 'SongsToTheSiren::Test::Role';

has '+user_base' => (default => 'form_val_3');

use SongsToTheSiren::Form::Field::Validator::MinLength;

sub run {
	my $self = shift;
	
	my $tests = [
		{ min => 1, data => undef,      expected => 'Minimum length 1' },
		{ min => 3, data => undef,      expected => 'Minimum length 3' },
		{ min => 2, data => '',         expected => 'Minimum length 2' },
		{ min => 2, data => ' ',        expected => 'Minimum length 2' },
		{ min => 2, data => '  ',       expected => undef              },
		{ min => 2, data => 'a',        expected => 'Minimum length 2' },
		{ min => 2, data => 'aa',       expected => undef              },
		{ min => 2, data => 'aaa',      expected => undef              },
		{ min => 2, data => 'è',        expected => 'Minimum length 2' },
		{ min => 2, data => 'èœ',       expected => undef              },
	];


	foreach my $test (@$tests){
		my $min = $test->{min};
		my $validator = SongsToTheSiren::Form::Field::Validator::MinLength->new(min => $min, schema => $self->schema);

		my $actual = $validator->validate($test->{data});
		my $expected = $test->{expected};
		if (defined $expected) {
			is($actual, $expected, 'MinLength on "' . ($test->{data} // 'undef') . '" should return "' . $expected . '"');
		}
		else {
			ok(!defined($actual), 'MinLength on "' . ($test->{data} // 'undef') . '" should return undef');
		}
	}
    
    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
