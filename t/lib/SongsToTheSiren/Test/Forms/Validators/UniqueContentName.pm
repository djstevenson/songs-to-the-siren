package SongsToTheSiren::Test::Forms::Validators::UniqueContentName;
use Moose;
use namespace::autoclean;

use utf8;

use Test::More;
use Test::Exception;

extends 'SongsToTheSiren::Test::Base';
with 'SongsToTheSiren::Test::Role';

has '+user_base' => (default => 'form_val_9');

use SongsToTheSiren::Form::Field::Validator::UniqueContentName;

# Simpler than UniqueUserName as names here are case-sensitive
sub run {
	my $self = shift;

	# Create an admin user, who creates a page with name 'xyzzy'.
	my $user_data1 = $self->get_user_data;
	my $user_obj1  = $self->create_admin_user($user_data1);
	$user_obj1->admin_create_content({name => 'xyzzy', title => 'The title', markdown => 'The markdown'});

	my $tests = [
		{ data => 'xyzzy', expected => 'Content name already in use' },
		{ data => 'xyz2y', expected => undef                 },
	];

	my $validator = SongsToTheSiren::Form::Field::Validator::UniqueContentName->new(schema => $self->schema);
	foreach my $test (@$tests){
		my $actual = $validator->validate($test->{data});
		my $expected = $test->{expected};
		if (defined $expected) {
			is($actual, $expected, 'UniqueContentName on "' . ($test->{data} // 'undef') . '" should return "' . $expected . '"');
		}
		else {
			ok(!defined($actual), 'UniqueContentName on "' . ($test->{data} // 'undef') . '" should return undef');
		}
	}
    
    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
