package SongsToTheSiren::Test::Model::Song::Links;
use utf8;
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

sub _random_embed_link {
	my $s1 = random_user_key;
	my $s2 = random_user_key;
	my $s3 = random_user_key;
	my $s4 = random_user_key;
	my $s5 = random_user_key;

	return {
		embed_identifier  => $s3,
		embed_class       => $s5,
		embed_url         => "https://${s1}.example.com/${s2}.html",
		embed_description => $s4,
		list_priority     => 0,
	};
}

sub _random_list_link {
	my ($priority) = @_;

	my $s1 = random_user_key;
	my $s2 = random_user_key;
	my $s3 = random_user_key;
	my $s4 = random_user_key;

	return {
		embed_identifier  => '',
		list_css          => $s3,
		list_url          => "https://${s1}.example.com/${s2}.html",
		list_description  => $s4,
		list_priority     => $priority,
	};
}

sub _random_both_link {
	my ($priority) = @_;

	my $s1 = random_user_key;
	my $s2 = random_user_key;
	my $s3 = random_user_key;
	my $s4 = random_user_key;
	my $s5 = random_user_key;
	my $s6 = random_user_key;
	my $s7 = random_user_key;
	my $s8 = random_user_key;

	return {
		embed_identifier  => $s3,
		embed_class       => $s5,
		embed_url         => "https://${s1}.example.com/${s2}.html",
		embed_description => $s4,
		list_css          => $s3,
		list_url          => "https://${s6}.example.com/${s7}.html",
		list_description  => $s8,
		list_priority     => $priority,
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
		country          => '🇨🇴',
		released_at      => 'release',
	});

	my $song2 = $user->admin_create_song({
		summary_markdown => 'summary2',
		full_markdown    => 'full2',
		title            => 'title2',
		artist           => 'artist2',
		album            => 'album2',
		image            => 'image2',
		country          => '🇮🇳',
		released_at      => 'release2',
	});

	is($song1->links->count, 0, 'New song has no links');

	my $link1 = _random_embed_link;
	my $link2 = _random_list_link(20);
	my $link3 = _random_both_link(30);
	my $link4 = _random_embed_link;
	
	$song1->add_link($link1);
	is($song1->links->count, 1, 'After link1, song has one link');
	is($song1->links->embedded_links->count, 1, 'After link1, song has one embedded link');
	is($song1->links->in_list->count, 0, 'After link1, song has zero list links');
	is($song2->links->count, 0, 'Song2 has no links');


	my $link2_obj = $song1->add_link($link2);
	is($song1->links->count, 2, 'After link2, song has two links');
	is($song1->links->embedded_links->count, 1, 'After link2, song has one embedded link');
	is($song1->links->in_list->count, 1, 'After link2, song has one list link');
	is($song2->links->count, 0, 'Song2 still has no links');

	# Can add the same embedded link to another song, but it'll be
	# a new record (unlike tags).  This tests that identifiers are 'per-song'.

    # First, add links 3 and 4 to song1
	$song1->add_link($link3);
	is($song1->links->count, 3, 'After adding link 3, song1 has three links');
	is($song1->links->embedded_links->count, 2, 'After adding link 3, song1 has two embedded links');
	is($song1->links->in_list->count, 2, 'After adding link 3, song1 has two list links');
	$song1->add_link($link4);
	is($song1->links->count, 4, 'After adding link 4, song1 has four links');
	is($song1->links->embedded_links->count, 3, 'After adding link 3, song1 has three embedded links');
	is($song1->links->in_list->count, 2, 'After adding link 3, song1 has two list links');

    # Second, add link 4 to song2
	$song2->add_link($link3);
	is($song1->links->count, 4, 'After adding link 4 to song2, song1 has four links');
	is($song1->links->embedded_links->count, 3, 'After adding link 3 to song2, song1 has three embedded links');
	is($song1->links->in_list->count, 2, 'After adding link 3 to song2, song1 has two list links');

	is($song2->links->count, 1, 'After adding link 4 to song2, song2 has one link');
	is($song2->links->embedded_links->count, 1, 'After adding link 3 to song2, song2 has one embedded link');
	is($song2->links->in_list->count, 1, 'After adding link 3 to song2, song2 has one list link');


	# # Database should have five links
	my $schema = $self->schema;
	my $rs = $schema->resultset('Link');
	is($rs->count, 5, 'Five links are in the DB');

	# get song1 list links by priority order
	my @links = $song1->links->in_list->by_priority->all;
	is($links[0]->list_priority, $link2->{list_priority}, 'Song1 link1 has right priority');
	is($links[0]->list_url, $link2->{list_url}, 'Song1 link1 has right url');
	is($links[0]->list_description, $link2->{list_description}, 'Song1 link1 has right description');
	is($links[0]->list_css, $link2->{list_css}, 'Song1 link1 has right css');
	is($links[1]->list_priority, $link3->{list_priority}, 'Song1 link2 has right priority');
	is($links[1]->list_url, $link3->{list_url}, 'Song1 link2 has right url');
	is($links[1]->list_description, $link3->{list_description}, 'Song1 link2 has right description');
	is($links[1]->list_css, $link3->{list_css}, 'Song1 link2 has right css');
    ok(!defined($links[2]), 'Song1 link3 does not exist');

	# get song2 list links by priority order
	@links = $song2->links->in_list->by_priority->all;
	is($links[0]->list_priority, $link3->{list_priority}, 'Song2 link1 has right priority');
	is($links[0]->list_url, $link3->{list_url}, 'Song2 link1 has right url');
	is($links[0]->list_description, $link3->{list_description}, 'Song2 link1 has right description');
	is($links[0]->list_css, $link3->{list_css}, 'Song2 link1 has right css');
    ok(!defined($links[1]), 'Song2 link2 does not exist');


    # get song1 embedded links
	my $links = $song1->links->embedded_links->by_identifier;
    ok( exists $links->{$link1->{embed_identifier}}, 'Song1 has link1 embedded');

    my $link = $links->{$link1->{embed_identifier}};
	is($link->embed_description, $link1->{embed_description}, 'Song1 link1 has right description');
	is($link->embed_class, $link1->{embed_class}, 'Song1 link1 has right class');
	is($link->embed_url, $link1->{embed_url}, 'Song1 link1 has right url');

    $link = $links->{$link3->{embed_identifier}};
	is($link->embed_description, $link3->{embed_description}, 'Song1 link3 has right description');
	is($link->embed_class, $link3->{embed_class}, 'Song1 link3 has right class');
	is($link->embed_url, $link3->{embed_url}, 'Song1 link3 has right url');

    $link = $links->{$link4->{embed_identifier}};
	is($link->embed_description, $link4->{embed_description}, 'Song1 link4 has right description');
	is($link->embed_class, $link4->{embed_class}, 'Song1 link4 has right class');
	is($link->embed_url, $link4->{embed_url}, 'Song1 link4 has right url');

    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
