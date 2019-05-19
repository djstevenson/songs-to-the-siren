package NeverTire::Table::Factory;
use namespace::autoclean;
use Moose;

use Class::Load;

sub table{
	my ($self, $name, $options) = @_;
	$options ||= {};

	my $class_name = 'NeverTire::Table::' . $name;
	Class::Load::load_class($class_name);
	return $class_name->new($options);
}

__PACKAGE__->meta->make_immutable;

1;
