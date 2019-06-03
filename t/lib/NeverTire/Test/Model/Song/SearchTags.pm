package NeverTire::Test::Model::Song::SearchTags;
use Moose;
use namespace::autoclean;

use utf8;

use Test::More;
use Test::Exception;
use Test::Deep qw/ cmp_deeply /;

extends 'NeverTire::Test::Base';
with 'NeverTire::Test::Role';

has '+user_base' => (default => 'model_5');

sub run {
	my $self = shift;
	
    my $schema = $self->schema;
	my $rs     = $schema->resultset('Tag');

	my $tag1 = $rs->create({name => 'tag1'});
	my $tag2 = $rs->create({name => 'tag2'});
	my $tag3 = $rs->create({name => 'tag3'});
	my $tag4 = $rs->create({name => 'tag4'});
	my $tag5 = $rs->create({name => 'tag5'});

	my %tests = (
		'Tag does not exist' => {
			tags => '9',
			expected => [],
		},
		'Tag 1' => {
			tags => '1',
			expected => [1],
		},
		'Tag 1,2' => {
			tags => '1,2',
			expected => [1,2],
		},
		'Tag 2,1' => {
			tags => '2,1',
			expected => [1,2],
		},
		'All tags' => {
			tags => '4,5,2,1,3',
			expected => [1,2,3,4,5],
		},
		'All tags - different order' => {
			tags => '1,2,3,4,5',
			expected => [1,2,3,4,5],
		},
		'Some good tags plus bad one' => {
			tags => '9,3,4,5',
			expected => [3,4,5],
		},
	);

	foreach my $desc ( keys %tests ) {
		my $t = $tests{$desc};
		my $res = $rs->search_by_ids( $t->{tags} );
		my @actual = map {$_->id} @{ $res };
		my @expected = @{ $t->{expected} };
		cmp_deeply([sort @actual], [sort @expected], $desc);
	}


    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
