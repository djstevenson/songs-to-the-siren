package NeverTire::Test::Model::Comment::ForestAdmin;
use Moose;
use namespace::autoclean;

# Tests for non-admin logged-in users, who should only see
# modded comments and their own unmodded comments.

# TODO Merge these into main comment forest tests, there is too much dupe code as is.

use utf8;

use Test::More;
use Test::Exception;
use Test::Deep qw/ cmp_deeply /;

use DateTime;

extends 'NeverTire::Test::Base';
with 'NeverTire::Test::Role';

has '+user_base' => (default => 'model_c1');

sub run {
	my $self = shift;
	
    my $admin = $self->create_admin_user;
    my $user  = $self->create_user;
    my $user2 = $self->create_user;

	my $song_data = {
		summary_markdown => 'This is the summary',
		full_markdown    => 'This is the full article about the song',
		title            => 'The song title',
		artist           => 'The artist name',
		album            => 'Greatest hits',
		image            => 'http://example.com/image.jpg',
		country          => $self->create_country('CO'),
		released_at      => 'Last week',
	};

	my $song = $admin->admin_create_song($song_data);

	my $first_root_comment;
	my $second_root_comment;
	subtest 'Test without any comments' => sub {
		my $forest = $song->get_comment_forest($user);
		is(scalar @$forest, 0, 'No comments -> empty forest');
	};

	subtest 'I add one comment, admin does not mod it, admin should still see it' => sub {
		$first_root_comment = $self->_create_comment($user, $song, undef, 'Markdown 1');

		my $forest = $song->get_comment_forest($admin);
		is(scalar @$forest, 1, 'Admin sees unmodded comments');
	};


	subtest 'Approve the single comment' => sub {
		$admin->approve_comment($first_root_comment);
		ok($first_root_comment->approved_at, "Comment is NOW approved");

		my $forest = $song->get_comment_forest($admin);
		is(scalar @$forest, 1, 'Admin still sees my comment after modding');
		is($forest->[0]->comment->id, $first_root_comment->id, 'Me: Root comment is right id');
	};

    done_testing;
}

# Too many args, but then it's a private method so &shrug; 
sub _create_comment {
	my ($self, $user, $song, $parent, $markdown) = @_;

	my $comment;

	if ( defined $parent ) {
		$comment = $user->new_song_comment($song, $parent, {comment_markdown => $markdown});
		is($comment->parent_id, $parent->id, "Comment has correct parent");
	}
	else {
		$comment = $user->new_song_comment($song, undef, {comment_markdown => $markdown});
		ok(!$comment->parent_id, "Comment has no parent");
	}

	# Assumes the simplest of markdown, string with no markdown in it..
	my $expected_markdown = "<p>$markdown</p>\n";
	is($comment->comment_html, $expected_markdown, "Comment has html");

	return $comment;
}

__PACKAGE__->meta->make_immutable;
1;
