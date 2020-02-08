package SongsToTheSiren::Test::Model::Song::NonAdmin;
use Moose;
use namespace::autoclean;

use utf8;

use Test::More;
use Test::Exception;
use DateTime;

extends 'SongsToTheSiren::Test::Base';
with 'SongsToTheSiren::Test::Role';

has '+user_base' => (default => 'model_4');

sub run {
	my $self = shift;
	
    my $admin_user = $self->create_admin_user;
    my $non_admin_user = $self->create_user;

	my $error = qr/Not admin - permission denied/;

	my $song_data = {
		summary_markdown => 'summary',
		full_markdown    => 'full',
		title            => 'title',
		artist           => 'artist',
		image            => 'image',
		album            => 'album',
		country          => $self->create_country('CO'),
		released_at      => 'release',
	};

	throws_ok {
		$non_admin_user->admin_create_song($song_data)
	} $error, 'Non-admin cannot create a song';

	my $song;
	lives_ok {
		$song = $admin_user->admin_create_song($song_data)
	} 'Admin can create a song';

	throws_ok {
		$non_admin_user->admin_edit_song($song, $song_data)
	} $error, 'Non-admin cannot edit a song';

    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
