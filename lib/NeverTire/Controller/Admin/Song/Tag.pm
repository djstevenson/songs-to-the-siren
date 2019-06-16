package NeverTire::Controller::Admin::Song::Tag;
use Mojo::Base 'Mojolicious::Controller';

sub add_routes {
    my ($c, $routes) = @_;

    my $ul = $routes->{admin_song_tag} ->any('/tag')->to(controller => 'Admin::Song::Tag');

    # These are admin functions, need to be logged in for all of them.
    $ul->route('/edit')->name('admin_edit_song_tags')->via('GET', 'POST')->to(action => 'edit');

    # Admin routes that capture a tag id
    my $tag_action = $ul->under('/:tag_id')->to(action => 'capture');

    # Remove a tag from a song. The tag isn't deleted from the DB
    # but is disassociated with this song.
    $tag_action->route->name('delete_song_tag')->via('DELETE')->to(action => 'delete');

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
        $c->redirect_to('admin_edit_song_tags', song_id => $song->id);
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

sub delete {
    my $c = shift;

    my $tag = $c->stash->{tag};
    $c->stash->{song}->delete_tag($tag);

    $c->render(text => '');
}

1;
