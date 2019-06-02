package NeverTire::Test::Model::Song::Update;
use Moose;
use namespace::autoclean;

use utf8;

use Test::More;
use Test::Exception;
use DateTime;

extends 'NeverTire::Test::Base';
with 'NeverTire::Test::Role';

has '+user_base' => (default => 'model_2');

sub run {
	my $self = shift;
	
    my $user = $self->create_admin_user;

	my $song = $user->create_song({
		summary_markdown => 'summary',
		full_markdown    => 'full',
		title            => 'title',
		artist           => 'artist',
		album            => 'album',
		date_released    => 'release',
	});
	my $dc = $song->date_created;

	my $summary = 'This is the summary';
	my $full    = 'This is the full article about the song';
	my $title   = 'The song title';
	my $artist  = 'The artist name';
	my $album   = 'Greatest hits';
	my $release = 'Last week';
	my $edited_song = $user->edit_song($song => {
		summary_markdown => $summary,
		full_markdown    => $full,
		title            => $title,
		artist           => $artist,
		album            => $album,
		date_released    => $release,
	});

	ok($song, 'Updated a song');
	is($edited_song->id, $song->id, 'Edited song has same id');
	is($song->summary_html,  "<p>${summary}</p>\n", 'Summary html is correct');
	is($song->full_html,     "<p>${full}</p>\n",    'Full html is correct');
	is($song->title,         $title,                'Title is correct');
	is($song->artist,        $artist,               'Artist is correct');
	is($song->album,         $album,                'Album is correct');
	is($song->date_released, $release,              'Release date is correct');

	is($song->date_created, $dc, 'Editing does not change date_created');

	my $du  = $song->date_updated;
	ok($du, 'New song does have date_updated set');

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
