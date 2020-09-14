package SongsToTheSiren::Controller::Song::Comment;
use utf8;
use Mojo::Base 'Mojolicious::Controller';

use Carp;

sub add_routes {
    my ($c, $song_action) = @_;

    ## no critic (ValuesAndExpressions::ProhibitLongChainsOfMethodCalls)
    my $u = $song_action->require_sign_in->any('/comment')->to(controller => 'song-comment');

    $u->route('/create')->name('new_song_comment')->via('GET', 'POST')->to(action => 'create');

    my $comment_action = $u->under('/:comment_id')->to(action => 'capture');

    $comment_action->route('/reply')->name('new_song_reply')->via('GET', 'POST')->to(action => 'reply');
    ## use critic
    
    return;
}

sub create {
    my $c = shift;

    my $song = $c->stash->{song};
    my $form = $c->form('Song::Comment::Create', song => $song);

    if ($form->process) {
        $c->flash(msg => 'Commented added - subject to moderation');

        $c->redirect_to('view_song', song_id => $song->id);
    }
    else {
        $c->stash(form => $form);
    }

    return;
}

sub capture {
    my $c = shift;

    my $comment_id = $c->stash->{comment_id};
    my $rs         = $c->schema->resultset('Comment');
    if (my $comment = $rs->find($comment_id)) {
        $c->stash(comment => $comment);
    }
    else {
        $c->reply->not_found;
        return undef;
    }

    return 1;
}

sub reply {
    my $c = shift;

    my $parent_comment = $c->stash->{comment};

    # TODO Redirect somewhere instead of throwing exception
    croak unless $parent_comment->approved_at;

    my $song = $parent_comment->song;

    my $form = $c->form('Song::Comment::Create', song => $song, parent_comment => $parent_comment);

    if ($form->process) {
        $c->flash(msg => 'Reply added - subject to moderation');

        $c->redirect_to('view_song', song_id => $song->id);
    }
    else {
        $c->stash(form => $form);
    }

    return;
}

1;
