package NeverTire::Form::Field::Validator::UniquePageName;
use Moose;

extends 'NeverTire::Form::Field::Validator::Base';
with 'NeverTire::Form::Field::Validator::Role';

sub validate{
	my ($self, $value) = @_;

	my $pages_rs = $self->schema->resultset('Page');
	my $found = $pages_rs->find_by_name($value);
	
    return 'Name already in use' if $found;
	return undef;
}


__PACKAGE__->meta->make_immutable;
1;
