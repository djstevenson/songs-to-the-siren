package NeverTire::Controller::Song::Comment;
use Mojo::Base 'Mojolicious::Controller';

sub add_routes {
    my ($c, $routes) = @_;

    # Need to be logged-in to comment
    my $ul = $routes->{login_song}   ->any('/comment')->to(controller => 'Song::Comment');
    
    $ul->route('/create')->name('new_song_comment')->via('GET', 'POST')->to(action => 'create');
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
}

1;
