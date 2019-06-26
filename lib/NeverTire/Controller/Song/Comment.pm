package NeverTire::Controller::Song::Comment;
use Mojo::Base 'Mojolicious::Controller';

sub add_routes {
    my ($c, $song_action) = @_;

    my $u = $song_action->any('/comment')->to(controller => 'Song::Comment');
    
    $u->route('/create')->name('new_song_comment')->via('GET', 'POST')->to(action => 'create');
}

sub create {
    my $c = shift;

    $c->assert_user;

    my $song = $c->stash->{song};
    my $form = $c->form('Song::Comment::Create', song => $song);
    
    if ($form->process) {
        $c->flash(msg => 'Commented added - subject to moderation');

        $c->redirect_to('view_song', song_id => $song->id);
    }
    else {
        $c->stash(form => $form);
    }
}

1;
