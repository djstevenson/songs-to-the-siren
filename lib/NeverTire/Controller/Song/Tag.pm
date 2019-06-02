package NeverTire::Controller::Song::Tag;
use Mojo::Base 'Mojolicious::Controller';

# $rl = base route for '/song/:id' tag admin actions

sub add_routes {
    my ($c, $rl) = @_;

    my $ul = $rl->any('/tag')->to(controller => 'Song::Tag');

    # These are admin functions, need to be logged in for all of them.
    $ul->route('/edit')->name('edit_song_tags')->via('GET', 'POST')->to(action => 'edit');

    # Admin routes that capture a tag id
    my $tag_action = $ul->under('/:tag_id')->to(action => 'capture');

    # Remove a tag from a song. The tag isn't deleted from the DB
    # but is disassociated with this song.
    $tag_action->route->name('remove_song_tag')->via('DELETE')->to(action => 'remove');

}


sub edit {
    my $c = shift;

    my $song = $c->stash->{song};
    my $form = $c->form('Tag::Create', song => $song);
    
    $c->stash(
        tags => [ $song->tags->all ],
        form => $form,
    );
    if ($form->process) {
        $c->flash(msg => 'Tag added');
        
        # Redirect so that form is reinitialised
        $c->redirect_to('edit_song_tags', song_id => $song->id);
    }

}

sub capture {
    my $c = shift;

    my $tag_id = $c->stash->{tag_id};
    if (my $tag = $c->schema->resultset('Tag')->find($tag_id)) {
        $c->stash(tag => $tag);
        return 1;
    }
    else {
        $c->reply->not_found;
        return undef;
    }
}

sub remove {
    my $c = shift;

    $c->stash->{song}->delete_tag($c->stash->{tag});

    $c->render(text => '');
}

1;
