package SongsToTheSiren::Test::Model::Song::SearchTags;
use utf8;
use Moose;
use namespace::autoclean;

use utf8;

use Test::More;
use Test::Exception;
use Test::Deep qw/ cmp_deeply /;

extends 'SongsToTheSiren::Test::Base';
with 'SongsToTheSiren::Test::Role';

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
			tag      => '9',
			expected => undef,
		},
		'Tag 1' => {
			tag      => $tag1->id,
			expected => $tag1->id,
		},
		'Tag 5' => {
			tag      => $tag5->id,
			expected => $tag5->id,
		},
	);

	foreach my $desc ( keys %tests ) {
		my $t = $tests{$desc};
		my $res = $rs->find( $t->{tag} );
		my $actual = $res ? $res->id : undef;
		my $expected = $t->{expected};
		is($actual, $expected, $desc);
	}


    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
