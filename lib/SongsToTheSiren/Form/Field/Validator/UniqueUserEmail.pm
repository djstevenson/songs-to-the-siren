package SongsToTheSiren::Form::Field::Validator::UniqueUserEmail;
use namespace::autoclean;
use Moose;

extends 'SongsToTheSiren::Form::Field::Validator::Base';
with 'SongsToTheSiren::Form::Field::Validator::Role';

sub validate{
	my ($self, $value) = @_;

	my $users_rs = $self->schema->resultset('User');
	my $found = $users_rs->find_by_email($value);
	
    return 'Email already registered' if $found;
	return undef;
}


__PACKAGE__->meta->make_immutable;
1;
