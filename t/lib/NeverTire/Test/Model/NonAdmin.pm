package NeverTire::Test::Model::NonAdmin;
use Moose;
use namespace::autoclean;

use utf8;

use Test::More;
use Test::Exception;
use DateTime;

extends 'NeverTire::Test::Base';
with 'NeverTire::Test::Role';

has '+user_base' => (default => 'model_4');

sub run {
	my $self = shift;
	
    my $admin_user = $self->create_admin_user;
    my $non_admin_user = $self->create_user;

	my $song_data = {
		summary_markdown => 'summary',
		full_markdown    => 'full',
		title            => 'title',
		artist           => 'artist',
		album            => 'album',
		date_released    => 'release',
	};

	throws_ok {
		$non_admin_user->create_song($song_data)
	} qr/Permission denied/, 'Non-admin cannot create a song';

	my $song;
	lives_ok {
		$song = $admin_user->create_song($song_data)
	} 'Admin can create a song';

	throws_ok {
		$non_admin_user->edit_song($song, $song_data)
	} qr/Permission denied/, 'Non-admin cannot edit a song';

    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
