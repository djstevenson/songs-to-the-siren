package NeverTire::Form::Field::Validator::UniqueContentName;
use Moose;

extends 'NeverTire::Form::Field::Validator::Base';
with 'NeverTire::Form::Field::Validator::Role';

sub validate{
	my ($self, $value) = @_;

	my $content_rs = $self->schema->resultset('Content');
	my $found = $content_rs->find($value);
	
    return 'Content name already in use' if $found;
	return undef;
}


__PACKAGE__->meta->make_immutable;
1;
