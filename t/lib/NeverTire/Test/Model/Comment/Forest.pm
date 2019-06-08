package NeverTire::Test::Model::Comment::Forest;
use Moose;
use namespace::autoclean;

use utf8;

use Test::More;
use Test::Exception;
use DateTime;

extends 'NeverTire::Test::Base';
with 'NeverTire::Test::Role';

has '+user_base' => (default => 'model_c1');

sub run {
	my $self = shift;
	
    my $admin = $self->create_admin_user;
    my $user  = $self->create_user;

	my $summary = 'This is the summary';
	my $full    = 'This is the full article about the song';
	my $title   = 'The song title';
	my $artist  = 'The artist name';
	my $album   = 'Greatest hits';
	my $release = 'Last week';
	
	my $song = $admin->admin_create_song({
		summary_markdown => $summary,
		full_markdown    => $full,
		title            => $title,
		artist           => $artist,
		album            => $album,
		released_at      => $release,
	});

	my $first_root_comment;
	subtest 'Test without any comments' => sub {
		my $forest = $song->comment_forest;
		is(scalar @$forest, 0, 'No comments -> empty forest');
	};

	subtest 'Add one "root" comment as admin, don\'t approve it' => sub {
		$first_root_comment = $self->_create_comment($admin, $song, undef, 'Markdown 1');

		my $forest = $song->comment_forest;
		is(scalar @$forest, 0, 'Only unapproved comments -> empty forest');
	};

	subtest 'Approve the single comment' => sub {
		$admin->approve_comment($first_root_comment);
		ok($first_root_comment->approved_at, "Comment is NOW approved");

		my $forest = $song->comment_forest;
		is(scalar @$forest, 1, 'Forest now has one root comment');
		is($forest->[0]->comment->id, $first_root_comment->id, 'Root comment is right id')
	};


    done_testing;
}

# Too many args, but then it's a private method so &shrug; 
sub _create_comment {
	my ($self, $user, $song, $parent, $markdown) = @_;

	my $comment = $user->comment_on_song($song, $parent, $markdown);

	if ( defined $parent ) {
		is($comment->parent_id, $parent->id, "Comment has correct parent");	
	}
	else {
		ok(!$comment->parent_id, "Comment has no parent");
	}

	# Assumes the simplest of markdown, string with no markdown in it..
	my $expected_markdown = "<p>$markdown</p>\n";
	is($comment->comment_html, $expected_markdown, "Comment has html");
	ok(!$comment->approved_at, "Comment is not approved");

	return $comment;
}

__PACKAGE__->meta->make_immutable;
1;
