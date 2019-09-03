package NeverTire::Form::Field::Validator::UniqueContentName;
use Moose;

extends 'NeverTire::Form::Field::Validator::Base';
with 'NeverTire::Form::Field::Validator::Role';

sub validate{
	my ($self, $value) = @_;

	my $pages_rs = $self->schema->resultset('Content');
	my $found = $pages_rs->find($value);
	
    return 'Name already in use' if $found;
	return undef;
}


__PACKAGE__->meta->make_immutable;
1;
