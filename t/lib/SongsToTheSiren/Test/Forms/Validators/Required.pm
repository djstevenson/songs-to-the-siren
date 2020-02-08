package SongsToTheSiren::Test::Forms::Validators::Required;
use Moose;
use namespace::autoclean;

use Test::More;
use Test::Exception;

extends 'SongsToTheSiren::Test::Base';
with 'SongsToTheSiren::Test::Role';

has '+user_base' => (default => 'form_val_1');

use SongsToTheSiren::Form::Field::Validator::Required;

sub run {
	my $self = shift;
	
	my $tests = [
		{ data => undef,      expected => 'Required' },
		{ data => '',         expected => 'Required' },
		{ data => ' a',       expected => undef      },
		{ data => ' ',        expected => undef      },
		{ data => 'a',        expected => undef      },
	];

	my $validator = SongsToTheSiren::Form::Field::Validator::Required->new(schema => $self->schema);
	foreach my $test (@$tests){
		my $actual = $validator->validate($test->{data});

		my $expected = $test->{expected};
		if (defined $expected) {
			is($actual, $expected, 'Required on "' . ($test->{data} // 'undef') . '" should return "' . $expected . '"');
		}
		else {
			ok(!defined($actual), 'Required on "' . ($test->{data} // 'undef') . '" should return undef');
		}
	}
    
    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
