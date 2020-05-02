package SongsToTheSiren::Test::Model::Song::Update;
use Moose;
use namespace::autoclean;

use utf8;

use Test::More;
use Test::Exception;
use DateTime;

extends 'SongsToTheSiren::Test::Base';
with 'SongsToTheSiren::Test::Role';

has '+user_base' => (default => 'model_2');

sub run {
	my $self = shift;
	
    my $user = $self->create_admin_user;

	my $song = $user->admin_create_song({
		summary_markdown => 'summary',
		full_markdown    => 'full',
		title            => 'title',
		artist           => 'artist',
		album            => 'album',
		image            => 'image',
		country          => '🇻🇺',
		released_at      => 'release',
	});
	my $dc = $song->created_at;

	my $summary = 'This is the summary';
	my $full    = 'This is the full article about the song';
	my $title   = 'The song title';
	my $artist  = 'The artist name';
	my $country = '🇹🇩';
	my $album   = 'Greatest hits';
	my $image   = 'New image';
	my $release = 'Last week';
	my $edited_song = $user->admin_edit_song($song => {
		summary_markdown => $summary,
		full_markdown    => $full,
		title            => $title,
		artist           => $artist,
		album            => $album,
		image            => $image,
		country          => $country,
		released_at      => $release,
	});

	ok($song, 'Updated a song');
	is($edited_song->id, $song->id, 'Edited song has same id');
	is($song->summary_html,  "<p>${summary}</p>\n", 'Summary html is correct');
	is($song->full_html,     "<p>${full}</p>\n",    'Full html is correct');
	is($song->title,         $title,                'Title is correct');
	is($song->artist,        $artist,               'Artist is correct');
	is($song->country,       $country,              'Country emoji is correct');
	is($song->album,         $album,                'Album is correct');
	is($song->image,         $image,                'Image is correct');
	is($song->released_at,   $release,              'Release date is correct');

	is($song->created_at, $dc, 'Editing does not change created_at');

	my $du  = $song->updated_at;
	ok($du, 'New song does have updated_at set');

	my $now = DateTime->now(time_zone => 'Europe/London');
	my $diff = $now->subtract_datetime($du)->in_units('seconds');
	ok($diff < 4 && $diff >= 0, 'Date updated is very recent, using Europe/London');

	$now = DateTime->now(time_zone => 'America/Chicago');
	$diff = $now->subtract_datetime($du)->in_units('seconds');
	ok($diff < 4 && $diff >= 0, 'Date updated is very recent, using America/Chicago');

	# Southern hemisphere, cos different DST.
	# Though this is really testing DateTime rather than my code...
	$now = DateTime->now(time_zone => 'Australia/Sydney');
	$diff = $now->subtract_datetime($du)->in_units('seconds');
	ok($diff < 4 && $diff >= 0, 'Date updated is very recent, using Australia/Sydney');

	is($song->tags->count, 0, 'New song has no tags');

	is($user->songs->count, 1, 'User still has one song');

    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
