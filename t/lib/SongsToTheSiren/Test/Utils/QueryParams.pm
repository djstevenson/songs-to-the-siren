package SongsToTheSiren::Test::Utils::QueryParams;
use Moose;
use namespace::autoclean;

use utf8;

use Test::More;
use Test::Exception;

use SongsToTheSiren::Util::QueryParams qw/ add_id_to_param remove_id_from_param /;

extends 'SongsToTheSiren::Test::Base';
with 'SongsToTheSiren::Test::Role';

has '+user_base' => (default => 'utils_1');


my %add_tests = (
	'Add id to empty param' => {
		list => '',
		add_id => 1,
		expected => '?test=1',
	},

	'Add id to single-item param, not already there' => {
		list => '1',
		add_id => 2,
		expected => '?test=1,2',
	},

	'Add id to two-item param, not already there' => {
		list => '2,1',
		add_id => 3,
		expected => '?test=2,1,3',
	},

	'Add id to single-item param, already there' => {
		list => '1',
		add_id => 1,
		expected => '?test=1',
	},

	# Order changes here cos we remove then add.
	# TODO Shouldn't care about ordering
	'Add id to two-item param, already there' => {
		list => '2,1',
		add_id => 2,
		expected => '?test=1,2',
	},
);

my %remove_tests = (
	'Remove id from empty param' => {
		list => '',
		remove_id => 1,
		expected => '',
	},

	'Remove id from single-item param, not already there' => {
		list => '1',
		remove_id => 2,
		expected => '?test=1',
	},

	'Remove id from single-item param, already there' => {
		list => '1',
		remove_id => 1,
		expected => '',
	},

	'Remove id from two-item param, not already there' => {
		list => '2,1',
		remove_id => 3,
		expected => '?test=2,1',
	},

	'Remove id from two-item param, already there, first' => {
		list => '2,1',
		remove_id => 2,
		expected => '?test=1',
	},

	'Remove id from two-item param, already there, second' => {
		list => '2,1',
		remove_id => 1,
		expected => '?test=2',
	},

	'Remove id from three-item param, already there, middle' => {
		list => '2,1,4',
		remove_id => 1,
		expected => '?test=2,4',
	},
);

sub run {
	my $self = shift;
	
	foreach my $desc (keys %add_tests) {
		my $t = $add_tests{$desc};
		my $actual   = add_id_to_param($t->{list}, 'test', $t->{add_id});
		my $expected = $t->{expected};

		is($actual, $expected, $desc);
	}

	foreach my $desc (keys %remove_tests) {
		my $t = $remove_tests{$desc};
		my $actual   = remove_id_from_param($t->{list}, 'test', $t->{remove_id});
		my $expected = $t->{expected};

		is($actual, $expected, $desc);
	}

    done_testing;
}



__PACKAGE__->meta->make_immutable;
1;
