package SongsToTheSiren::Test::Forms::Validators::ValidInteger;
use utf8;
use Moose;
use namespace::autoclean;

use utf8;

use Test::More;
use Test::Exception;

extends 'SongsToTheSiren::Test::Base';
with 'SongsToTheSiren::Test::Role';

has '+user_base' => (default => 'form_val_7');

use SongsToTheSiren::Form::Field::Validator::ValidInteger;

sub run {
	my $self = shift;
	
	my $tests = [
		# Don't test blank data, it should already be validated
		# This is for an id, for which 0 is not valid
		{ data => '0',                      expected => undef },
		{ data => '01',                     expected => undef },
		{ data => '2',                      expected => undef },
		{ data => '99999',                  expected => undef },
		{ data => '01a',                    expected => 'Invalid number' },
		{ data => 'a2',                     expected => 'Invalid number' },
		{ data => '2a2',                    expected => 'Invalid number' },
	];

	my $validator = SongsToTheSiren::Form::Field::Validator::ValidInteger->new(schema => $self->schema);
	foreach my $test (@$tests){
		my $actual = $validator->validate($test->{data});
		my $expected = $test->{expected};
		if (defined $expected) {
			is($actual, $expected, 'ValidInteger on "' . ($test->{data} // 'undef') . '" should return "' . $expected . '"');
		}
		else {
			ok(!defined($actual), 'ValidInteger on "' . ($test->{data} // 'undef') . '" should return undef');
		}
	}
    
    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
