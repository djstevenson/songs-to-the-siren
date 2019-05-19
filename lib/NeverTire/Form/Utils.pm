package NeverTire::Form::Utils;
use Moose;
use namespace::autoclean;

use Class::Load;

use Sub::Exporter -setup => {
	exports => [qw/ load_form_objects /]
};

sub load_form_objects{
	my ($source_data, $class_prefix, $args) = @_;
	
	my @o;
	
	foreach my $source_item (@$source_data){
		my $class_name;
		my %xargs = %$args;
		if (ref($source_item) eq 'ARRAY'){
			$class_name =  $source_item->[0];
			%xargs      =  (%xargs, %{$source_item->[1]}),
		}
		else {
			$class_name = $source_item;
		}
		
		my $full_class_name = $class_prefix . '::' . $class_name;
		Class::Load::load_class($full_class_name);
		
		push @o, $full_class_name->new(%xargs);
	}
	return \@o;
}

__PACKAGE__->meta->make_immutable;
1;
