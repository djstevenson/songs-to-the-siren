package SongsToTheSiren::Controller::Admin::Song::Comment;
use utf8;
use Mojo::Base 'Mojolicious::Controller';

sub add_routes {
    my ($c, $song_action) = @_;

    # $song_action has checked that we're logged-in, but not that we're admin

    ## no critic (ValuesAndExpressions::ProhibitLongChainsOfMethodCalls)
    my $u = $song_action->require_admin->any('/comment')->to(controller => 'admin-song-comment');

    my $comment_action = $u->under('/:comment_id')->to(action => 'capture');

    $comment_action->any(['GET', 'POST'] => '/approve')->name('admin_approve_comment')->to(action => 'approve');
    $comment_action->any(['GET', 'POST'] => '/reject')->name('admin_reject_comment')->to(action   => 'reject');
    $comment_action->any(['GET', 'POST'] => '/edit')->name('admin_edit_comment')->to(action       => 'edit');
    ## use critic

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

sub approve {
    my $c = shift;

    my $comment = $c->stash->{comment};
    my $song    = $comment->song;

    my $form = $c->form('Song::Comment::Approve', comment => $comment);

    if ($form->process) {
        $c->flash(msg => 'Comment approved');

        $c->redirect_to('view_song', song_id => $song->id);
    }
    else {
        $c->stash(form => $form);
    }

    return;
}

sub reject {
    my $c = shift;

    my $comment = $c->stash->{comment};
    my $song    = $comment->song;

    my $form = $c->form('Song::Comment::Reject', comment => $comment);

    if ($form->process) {
        $c->flash(msg => 'Comment rejected');

        $c->redirect_to('view_song', song_id => $song->id);
    }
    else {
        $c->stash(form => $form);
    }

    return;
}

sub edit {
    my $c = shift;

    my $comment = $c->stash->{comment};
    my $song    = $comment->song;

    my $form = $c->form('Song::Comment::Edit', comment => $comment);

    if ($form->process) {
        $c->flash(msg => 'Comment edited');

        $c->redirect_to('view_song', song_id => $song->id);
    }
    else {
        $c->stash(form => $form);
    }

    return;
}


1;
