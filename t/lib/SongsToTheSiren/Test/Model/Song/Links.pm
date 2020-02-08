package SongsToTheSiren::Test::Model::Song::Links;
use Moose;
use namespace::autoclean;

use utf8;

use Test::More;
use Test::Exception;
use DateTime;
use SongsToTheSiren::Util::Password qw/ random_user_key /;

extends 'SongsToTheSiren::Test::Base';
with 'SongsToTheSiren::Test::Role';

has '+user_base' => (default => 'model_6');

sub _random_link {
	my ($priority, $extras) = @_;

	my $s1 = random_user_key;
	my $s2 = random_user_key;
	my $s3 = random_user_key;
	my $s4 = random_user_key;
	my $s5 = random_user_key;

	return {
		identifier  => $s3,
		class       => $s5,
		url         => "https://${s1}.example.com/${s2}.html",
		description => $s4,
		priority    => $priority,
		extras      => $extras,
	};
}

sub run {
	my $self = shift;
	
    my $user = $self->create_admin_user;

	my $song1 = $user->admin_create_song({
		summary_markdown => 'summary',
		full_markdown    => 'full',
		title            => 'title',
		artist           => 'artist',
		album            => 'album',
		image            => 'image',
		country          => $self->create_country('CO'),
		released_at      => 'release',
	});

	my $song2 = $user->admin_create_song({
		summary_markdown => 'summary2',
		full_markdown    => 'full2',
		title            => 'title2',
		artist           => 'artist2',
		album            => 'album2',
		image            => 'image2',
		country          => $self->create_country('CX'),
		released_at      => 'release2',
	});

	is($song1->links->count, 0, 'New song has no links');

	my $link1 = _random_link(10);
	my $link2 = _random_link(20);
	my $link3 = _random_link(30);
	my $link4 = _random_link(5, '16x9');
	
	$song1->add_link($link1);
	is($song1->links->count, 1, 'After link1, song has one link');
	$song1->add_link($link2);
	is($song1->links->count, 2, 'After link2, song has two links');
	is($song2->links->count, 0, 'Song2 still has no links');

	# Can add the same link to another song, but it'll be
	# a new record (unlike tags). Adding the same link 
	# to two songs is an unlikely scenario.
	$song2->add_link($link3);
	$song2->add_link($link4);
	is($song2->links->count, 2, 'After adding links 2/3, song2 has two links');
	$song2->add_link($link1);
	is($song2->links->count, 3, 'After adding link 1, song2 has three links');
	is($song1->links->count, 2, 'After adding link 1, song1 still has two links');

	# Database should have five links
	my $schema = $self->schema;
	my $rs = $schema->resultset('Link');
	is($rs->count, 5, 'Five links are in the DB');

	# get by priority order
	my @links = $song1->links->by_priority->all;
	is($links[0]->identifier, $link1->{identifier}, 'Song1 link1 has right identifier');
	is($links[0]->url,  $link1->{url},  'Song1 link1 has right url');
	is($links[1]->identifier, $link2->{identifier}, 'Song1 link2 has right identifier');
	is($links[1]->url,  $link2->{url},  'Song1 link2 has right url');

	@links = $song2->links->by_priority->all;
	is($links[0]->identifier, $link4->{identifier}, 'Song2 link1 has right identifier');
	is($links[0]->url,  $link4->{url},  'Song2 link1 has right url');
	is($links[1]->identifier, $link1->{identifier}, 'Song2 link2 has right identifier');
	is($links[1]->url,  $link1->{url},  'Song2 link2 has right url');
	is($links[2]->identifier, $link3->{identifier}, 'Song2 link3 has right identifier');
	is($links[2]->url,  $link3->{url},  'Song2 link3 has right url');


	# In templates, we may want to get links by name, e.g. to 
	# link to the youtube video. Test that:
	my $links_by_identifier = $song1->links->links_by_identifier;
	# links_by_identifier returned hash, k=name, v=result object
	is($links_by_identifier->{$link1->{identifier}}->url, $link1->{url}, 'get by identifier: song1 has right link for link1');
	is($links_by_identifier->{$link2->{identifier}}->url, $link2->{url}, 'get by identifier: song1 has right link for link2');

	# And check extras while we're at it, for song2
	$links_by_identifier = $song2->links->links_by_identifier;
	is($links_by_identifier->{$link1->{identifier}}->url,    $link1->{url}, 'get by identifier: song2 has right link for link1');
	is($links_by_identifier->{$link1->{identifier}}->extras, undef,         'get by identifier: song2 has right extras for link1');
	is($links_by_identifier->{$link3->{identifier}}->url,    $link3->{url}, 'get by identifier: song2 has right link for link3');
	is($links_by_identifier->{$link3->{identifier}}->extras, undef,         'get by identifier: song2 has right extras for link3');
	is($links_by_identifier->{$link4->{identifier}}->url,    $link4->{url}, 'get by identifier: song2 has right link for link4');
	is($links_by_identifier->{$link4->{identifier}}->extras, '16x9',        'get by identifier: song2 has right extras for link4');

    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
