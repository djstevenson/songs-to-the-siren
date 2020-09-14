package SongsToTheSiren::Test::Utils::List;
use utf8;
use Moose;
use namespace::autoclean;

use utf8;

use Test::More;
use Test::Exception;
use Test::Deep qw/ cmp_deeply /;

use SongsToTheSiren::Util::List qw/ add_id_to_list remove_id_from_list /;

extends 'SongsToTheSiren::Test::Base';
with 'SongsToTheSiren::Test::Role';

has '+user_base' => (default => 'utils_2');


my %add_tests = (
	'Add id to empty param' => {
		list => '',
		add_id => 1,
		expected => [1],
	},

	'Add id to single-item param, not already there' => {
		list => '1',
		add_id => 2,
		expected => [1,2],
	},

	'Add id to two-item param, not already there' => {
		list => '2,1',
		add_id => 3,
		expected => [2,1,3],
	},

	'Add id to single-item param, already there' => {
		list => '1',
		add_id => 1,
		expected => [1],
	},

	# Order changes here cos we remove then add.
	# TODO Shouldn't care about ordering
	'Add id to two-item param, already there' => {
		list => '2,1',
		add_id => 2,
		expected => [1,2],
	},
);

my %remove_tests = (
	'Remove id from empty param' => {
		list => '',
		remove_id => 1,
		expected => [],
	},

	'Remove id from single-item param, not already there' => {
		list => '1',
		remove_id => 2,
		expected => [1],
	},

	'Remove id from single-item param, already there' => {
		list => '1',
		remove_id => 1,
		expected => [],
	},

	'Remove id from two-item param, not already there' => {
		list => '2,1',
		remove_id => 3,
		expected => [2,1],
	},

	'Remove id from two-item param, already there, first' => {
		list => '2,1',
		remove_id => 2,
		expected => [1],
	},

	'Remove id from two-item param, already there, second' => {
		list => '2,1',
		remove_id => 1,
		expected => [2],
	},

	'Remove id from three-item param, already there, middle' => {
		list => '2,1,4',
		remove_id => 1,
		expected => [2,4],
	},
);

sub run {
	my $self = shift;
	
	foreach my $desc (keys %add_tests) {
		my $t = $add_tests{$desc};
		my $actual   = [ add_id_to_list($t->{list}, $t->{add_id}) ];
		my $expected = $t->{expected};

		cmp_deeply($actual, $expected, $desc);
	}

	foreach my $desc (keys %remove_tests) {
		my $t = $remove_tests{$desc};
		my $actual   = [ remove_id_from_list($t->{list}, $t->{remove_id}) ];
		my $expected = $t->{expected};

		cmp_deeply($actual, $expected, $desc);
	}

    done_testing;
}



__PACKAGE__->meta->make_immutable;
1;
