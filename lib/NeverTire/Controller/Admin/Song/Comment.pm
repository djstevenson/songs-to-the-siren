package NeverTire::Controller::Admin::Song::Comment;
use Mojo::Base 'Mojolicious::Controller';

sub add_routes {
    my ($c, $song_action) = @_;

    # $song_action has checked that we're logged-in, but not that we're admin

    my $u = $song_action->require_admin->any('/comment')->to(controller => 'admin-song-comment');
    
    my $comment_action = $u->under('/:comment_id')->to(action => 'capture');

    $comment_action->route('/approve')->name('admin_approve_comment')->via('GET', 'POST')->to(action => 'approve');
    $comment_action->route('/reject')->name('admin_reject_comment')->via('GET', 'POST')->to(action => 'reject');
}

sub capture {
    my $c = shift;

    my $comment_id = $c->stash->{comment_id};
    my $rs = $c->schema->resultset('Comment');
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

    my $form = $c->form( 'Song::Comment::Approve', comment => $comment );
    
    if (my $action = $form->process) {
        $c->flash(msg => $action);

        $c->redirect_to('view_song', song_id => $song->id);
    }
    else {
        $c->stash(form => $form);
    }
}

sub reject {
    my $c = shift;

    my $comment = $c->stash->{comment};
    my $song    = $comment->song;

    my $form = $c->form( 'Song::Comment::Reject', comment => $comment );
    
    if (my $action = $form->process) {
        $c->flash(msg => $action);

        $c->redirect_to('view_song', song_id => $song->id);
    }
    else {
        $c->stash(form => $form);
    }
}


1;
