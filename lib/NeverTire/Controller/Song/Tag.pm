package NeverTire::Controller::Song::Tag;
use Mojo::Base 'Mojolicious::Controller';

sub add_routes {
    my ($c, $song_action) = @_;

    my $u = $song_action->any('/tag')->to(controller => 'Song::Tag');

    # Actions that do not capture a tag_id
    $u->route('/edit')->name('edit_song_tags')->via('GET', 'POST')->to(action => 'edit');

    # Actions that DO capture a tag_id
    my $tag_action = $u->under('/:tag_id')->to(action => 'capture');

    # Remove a tag from a song
    $tag_action->route->name('delete_song_tag')->via('DELETE')->to(action => 'delete');

}


sub edit {
    my $c = shift;

    return $c->render(status => 403, text => 'Nah')
        unless exists $c->stash->{admin_user};

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

sub delete {
    my $c = shift;

    return $c->render(status => 403, text => 'Nah')
        unless exists $c->stash->{admin_user};

    my $tag = $c->stash->{tag};
    $c->stash->{song}->delete_tag($tag);

    $c->render(text => '');
}

1;
