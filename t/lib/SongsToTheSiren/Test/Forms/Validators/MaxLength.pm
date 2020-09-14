package SongsToTheSiren::Test::Forms::Validators::MaxLength;
use utf8;
use Moose;
use namespace::autoclean;

use utf8;

use Test::More;
use Test::Exception;

extends 'SongsToTheSiren::Test::Base';
with 'SongsToTheSiren::Test::Role';

has '+user_base' => (default => 'form_val_2');

use SongsToTheSiren::Form::Field::Validator::MaxLength;

sub run {
	my $self = shift;
	
	my $tests = [
		{ max => 1, data => undef,      expected => undef              },
		{ max => 3, data => undef,      expected => undef              },
		{ max => 2, data => '',         expected => undef              },
		{ max => 2, data => ' ',        expected => undef              },
		{ max => 2, data => '  ',       expected => undef              },
		{ max => 2, data => 'aa',       expected => undef              },
		{ max => 2, data => 'aaa',      expected => 'Maximum length 2' },
		{ max => 2, data => '   ',      expected => 'Maximum length 2' },
		{ max => 2, data => 'è',        expected => undef              },
		{ max => 2, data => 'èœ',       expected => undef              },
		{ max => 2, data => 'èœč',      expected => 'Maximum length 2' },
	];

	foreach my $test (@$tests){
		my $max = $test->{max};
		my $validator = SongsToTheSiren::Form::Field::Validator::MaxLength->new(max => $max, schema => $self->schema);

		my $actual = $validator->validate($test->{data});
		my $expected = $test->{expected};
		if (defined $expected) {
			is($actual, $expected, 'MaxLength on "' . ($test->{data} // 'undef') . '" should return "' . $expected . '"');
		}
		else {
			ok(!defined($actual), 'MaxLength on "' . ($test->{data} // 'undef') . '" should return undef');
		}
	}
    
    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
