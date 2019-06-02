package NeverTire::Test::Model::Song::Tags;
use Moose;
use namespace::autoclean;

use utf8;

use Test::More;
use Test::Exception;
use DateTime;
use NeverTire::Util::Password qw/ random_user_key /;

extends 'NeverTire::Test::Base';
with 'NeverTire::Test::Role';

has '+user_base' => (default => 'model_3');

sub run {
	my $self = shift;
	
    my $user = $self->create_admin_user;

	my $song1 = $user->create_song({
		summary_markdown => 'summary',
		full_markdown    => 'full',
		title            => 'title',
		artist           => 'artist',
		album            => 'album',
		date_released    => 'release',
	});

	my $song2 = $user->create_song({
		summary_markdown => 'summary2',
		full_markdown    => 'full2',
		title            => 'title2',
		artist           => 'artist2',
		album            => 'album2',
		date_released    => 'release2',
	});

	is($song1->tags->count, 0, 'New song has no tags');

	my $tag1name = random_user_key();
	my $tag2name = random_user_key();
	my $tag3name = random_user_key();
	
	$song1->add_tag($tag1name);
	is($song1->tags->count, 1, 'After tag1name, song has one tag');
	$song1->add_tag($tag2name);
	is($song1->tags->count, 2, 'After tag2name, song has two tags');
	is($song2->tags->count, 0, 'Song2 still has no tags');

	$song2->add_tag($tag2name);
	$song2->add_tag($tag3name);
	is($song2->tags->count, 2, 'After adding tags 2/3, song2 has two tags');
	$song2->add_tag($tag1name);
	is($song2->tags->count, 3, 'After adding tag 1, song2 has three tags');
	is($song1->tags->count,  2, 'Song1 still has two tags');

	my $schema = $self->schema;
	my $rs = $schema->resultset('Tag');
	my $tag1 = $rs->find({name => $tag1name});
	my $tag2 = $rs->find({name => $tag2name});
	my $tag3 = $rs->find({name => $tag3name});

	is($tag1->songs->count, 2, 'Both songs have tag 1');
	is($tag2->songs->count, 2, 'Both songs have tag 2');
	is($tag3->songs->count, 1, 'One song has tag 3');

	# Delete a tag from the only song using it
	$song2->delete_tag($tag3);
	is($song2->tags->count, 2, 'After deleting tag 3, song2 has two tags');
	is($song1->tags->count, 2, '  and song1 still has two tags');
	ok(!$rs->find({name => $tag3name}), '  and tag 3 no longer exists');

	# Delete a tag from a song where the tag is still used by another song
	$song2->delete_tag($tag2);
	is($song2->tags->count, 1, 'After deleting tag 2, song2 has one tag');
	is($song1->tags->count, 2, '  and song1 still has two tags');
	ok($rs->find({name => $tag2name}), '  and tag 2 still exists');

    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
