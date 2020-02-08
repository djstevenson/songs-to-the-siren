package SongsToTheSiren::Test::Forms::Filters::TrimEdges;
use Moose;
use namespace::autoclean;

use utf8;

use Test::More;
use Test::Exception;

extends 'SongsToTheSiren::Test::Base';
with 'SongsToTheSiren::Test::Role';

has '+user_base' => (default => 'form_filt_1');

use SongsToTheSiren::Form::Field::Filter::TrimEdges;

sub run {
	my $self = shift;
	
	my $tests = [
		{ data => '',         expected => ''      },
		{ data => ' ',        expected => ''      },
		{ data => '  ',       expected => ''      },
		{ data => 'abcdef',   expected => 'abcdef'},
		{ data => 'abc ef',   expected => 'abc ef'},
		{ data => ' bcdef',   expected => 'bcdef' },
		{ data => '  cdef',   expected => 'cdef'  },
		{ data => '  cde ',   expected => 'cde'   },
		{ data => '  cd  ',   expected => 'cd'    },
		{ data => '  c  d  ', expected => 'c  d'  },
	];

	my $filter = SongsToTheSiren::Form::Field::Filter::TrimEdges->new(schema => $self->schema);
	foreach my $test (@$tests){
		my $actual = $filter->filter($test->{data});
		is($actual, $test->{expected}, "TrimEdges on " . $test->{data} . ' should return ' . $test->{expected});
	}
    
    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
