package SongsToTheSiren::Test::Forms::MockForm;
use utf8;
use Moose;
use namespace::autoclean;

has id => (
	is          => 'ro',
	isa         => 'Str',
	default     => 'test-form',
);

__PACKAGE__->meta->make_immutable;
1;
