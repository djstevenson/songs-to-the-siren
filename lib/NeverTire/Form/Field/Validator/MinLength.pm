package NeverTire::Form::Field::Validator::MinLength;
use namespace::autoclean;
use Moose;

extends 'NeverTire::Form::Field::Validator::Base';
with 'NeverTire::Form::Field::Validator::Role';

has min => (
	is          => 'ro',
	isa         => 'Int',
	required    => 1,
);

sub validate{
	my ($self, $value) = @_;

	my $min = $self->min;
	
    return "Minimum length $min" if length($value // '') < $min;
	return undef;
}


__PACKAGE__->meta->make_immutable;
1;
