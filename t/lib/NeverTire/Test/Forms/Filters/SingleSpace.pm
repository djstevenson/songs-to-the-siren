package NeverTire::Test::Forms::Filters::SingleSpace;
use Moose;
use namespace::autoclean;

use utf8;

use Test::More;
use Test::Exception;

extends 'NeverTire::Test::Base';
with 'NeverTire::Test::Role';

has '+user_base' => (default => 'form_filt_2');

use NeverTire::Form::Field::Filter::SingleSpace;

sub run {
	my $self = shift;
	
	my $tests = [
		{ data => '',         expected => ''      },
		{ data => 'abcdef',   expected => 'abcdef'},
		{ data => 'abc ef',   expected => 'abc ef'},
		{ data => ' bcdef',   expected => ' bcdef'},
		{ data => 'abcde   ', expected => 'abcde '},
		{ data => 'abc   ef', expected => 'abc ef'},
		{ data => '   bcdef', expected => ' bcdef'},
		{ data => 'abcde   ', expected => 'abcde '},
		{ data => 'a  b   c', expected => 'a b c'},
		{ data => '        ', expected => ' '},
	];

	my $filter = NeverTire::Form::Field::Filter::SingleSpace->new(schema => $self->schema);
	foreach my $test (@$tests){
		my $actual = $filter->filter($test->{data});
		is($actual, $test->{expected}, "SingleSpace on " . $test->{data} . ' should return ' . $test->{expected});
	}
    
    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
