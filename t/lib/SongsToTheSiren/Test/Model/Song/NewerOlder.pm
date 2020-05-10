package SongsToTheSiren::Test::Model::Song::NewerOlder;
use Moose;
use namespace::autoclean;

use utf8;

use Test::More;
use Test::Exception;
use DateTime;
use SongsToTheSiren::Util::Password qw/ random_user_key /;

extends 'SongsToTheSiren::Test::Base';
with 'SongsToTheSiren::Test::Role';

has '+user_base' => (default => 'model_7');

sub run {
	my $self = shift;
	
    my $user = $self->create_admin_user;

	my $country = '🇨🇴';

	my $song1 = $user->admin_create_song({
		summary_markdown => 'summary',
		full_markdown    => 'full',
		title            => 'title',
		artist           => 'artist',
		album            => 'album',
		image            => 'image',
		country          => $country,
		released_at      => 'release',
	});

	# We have one song, so it has no newer/older
	$song1->show;
	my $nav = $song1->get_navigation;
	ok(! $nav->{newer}, 'Single song has no newer');
	ok(! $nav->{older}, 'Single song has no older');

	# Create a newer song, but don't publish it.
	# Orig song should still have nothing newer.
	# Newer song will have the orig as an older one though.
	my $song2 = $user->admin_create_song({
		summary_markdown => 'summary2',
		full_markdown    => 'full2',
		title            => 'title2',
		artist           => 'artist2',
		album            => 'album2',
		image            => 'image2',
		country          => $country,
		released_at      => 'release2',
	});

	$nav = $song1->get_navigation;
	ok(! $nav->{newer}, 'Unpublished song 2: song 1 has no newer');
	ok(! $nav->{older}, 'Unpublished song 2: song 1 has no older');
	$nav = $song2->get_navigation;
	ok(! $nav->{newer}, 'Unpublished song 2: song 2 has no newer');
	ok(! $nav->{older}, 'Unpublished song 2: song 2 has no older');

	# Publish 2, so it now shows up as newer for song 1
	$song2->show;
	$nav = $song1->get_navigation;
	is( $nav->{newer}->id, $song2->id, 'Published song 2: song 1 has song2 as newer');
	ok(! $nav->{older}, 'Published song 2: song 1 has no older');
	$nav = $song2->get_navigation;
	ok(! $nav->{newer}, 'Published song 2: song 2 has no newer');
	is( $nav->{older}->id, $song1->id, 'Published song 2: song 2 has song1 as older');

	# Add published song 3, so we can test that song2 has both newer and older
	my $song3 = $user->admin_create_song({
		summary_markdown => 'summary3',
		full_markdown    => 'full3',
		title            => 'title3',
		artist           => 'artist3',
		album            => 'album3',
		image            => 'image3',
		country          => $country,
		released_at      => 'release3',
	});
	$song3->show;

	$nav = $song1->get_navigation;
	is( $nav->{newer}->id, $song2->id, 'Published song 3: song 1 has song2 as newer');
	ok(! $nav->{older}, 'Published song 3: song 1 has no older');

	$nav = $song2->get_navigation;
	is( $nav->{newer}->id, $song3->id, 'Published song 3: song 2 has song3 as newer');
	is( $nav->{older}->id, $song1->id, 'Published song 3: song 2 has song1 as older');

	$nav = $song3->get_navigation;
	ok(! $nav->{newer}, 'Published song 3: song 3 has no newer');
	is( $nav->{older}->id, $song2->id, 'Published song 3: song 3 has song2 as older');

	# Unpublish song2 to show that we skip it, e.g. 
	# song3 older is song1
	$song2->hide;
	$nav = $song1->get_navigation;
	is( $nav->{newer}->id, $song3->id, 'Hidden song 2: song 1 has song3 as newer');
	ok(! $nav->{older}, 'Hidden song 2: song 1 has no older');

	$nav = $song3->get_navigation;
	ok(! $nav->{newer}, 'Hidden song 2: song 3 has no newer');
	is( $nav->{older}->id, $song1->id, 'Hidden song 2: song 3 has song1 as older');

	# REpublish song2 - it should now be the NEWEST
	$song2->show;
	$nav = $song2->get_navigation;
	is( $nav->{older}->id, $song3->id, 'Republished song 2: song 2 has song3 as older');
	ok(! $nav->{newer}, 'Republished song 2: song2 has no newer');

	$nav = $song3->get_navigation;
	is( $nav->{newer}->id, $song2->id, 'Republished song 2: song 3 has song2 newer');
	is( $nav->{older}->id, $song1->id, 'Republished song 2: song 3 has song1 as older');

    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
