package NeverTire::Test::Model::Song::New;
use Moose;
use namespace::autoclean;

use utf8;

use Test::More;
use Test::Exception;
use DateTime;

extends 'NeverTire::Test::Base';
with 'NeverTire::Test::Role';

has '+user_base' => (default => 'model_1');

sub run {
	my $self = shift;
	
    my $user     = $self->create_admin_user;

	is($user->songs->count, 0, 'New user has no songs');

	my $summary = 'This is the summary';
	my $full    = 'This is the full article about the song';
	my $title   = 'The song title';
	my $artist  = 'The artist name';
	my $country = $self->create_country('CO');
	my $album   = 'Greatest hits';
	my $image   = 'Album artwork';
	my $release = 'Last week';
	
	my $song = $user->admin_create_song({
		summary_markdown => $summary,
		full_markdown    => $full,
		title            => $title,
		artist           => $artist,
		country          => $country,
		album            => $album,
		image            => $image,
		released_at      => $release,
	});

	# Full markdown tests done elsewhere, here we just
	# check that _something_ is rendered.
	ok($song, 'Created a song');
	is($song->summary_html,  "<p>${summary}</p>\n", 'Summary html is correct');
	is($song->full_html,     "<p>${full}</p>\n",    'Full html is correct');
	is($song->title,         $title,                'Title is correct');
	is($song->artist,        $artist,               'Artist is correct');
	is($song->country_id,    $country->id,          'Country is correct');
	is($song->album,         $album,                'Album is correct');
	is($song->image,         $image,                'Image is correct');
	is($song->released_at,   $release,              'Release date is correct');

	my $dc  = $song->created_at;  # DateTime object
	ok($dc,  'New song does have created_at set');

	my $now = DateTime->now(time_zone => 'Europe/London');
	my $diff = $now->subtract_datetime($dc)->in_units('seconds');
	ok($diff < 4 && $diff >= 0, 'Date created is very recent, using Europe/London');

	$now = DateTime->now(time_zone => 'America/Chicago');
	$diff = $now->subtract_datetime($dc)->in_units('seconds');
	ok($diff < 4 && $diff >= 0, 'Date created is very recent, using America/Chicago');

	# Southern hemisphere, cos different DST.
	# Though this is really testing DateTime rather than my code...
	$now = DateTime->now(time_zone => 'Australia/Sydney');
	$diff = $now->subtract_datetime($dc)->in_units('seconds');
	ok($diff < 4 && $diff >= 0, 'Date created is very recent, using Australia/Sydney');

	ok(!$song->updated_at, 'New song does not have updated_at set');
	
	is($song->tags->count, 0, 'New song has no tags');

	is($user->songs->count, 1, 'User now has one song');
    my $user2 = $self->create_admin_user;
	is($user2->songs->count, 0, 'New user2 has no songs');

    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
