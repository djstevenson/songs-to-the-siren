package NeverTire::Controller::Admin::Song::Link;
use Mojo::Base 'Mojolicious::Controller';

sub add_routes {
    my ($c, $routes) = @_;

    my $ul = $routes->{admin_song_link} ->any('/link')->to(controller => 'Admin::Song::Link');

    $ul->route('/list')->name('admin_list_song_links')->via('GET')->to(action => 'list');

    # These are admin functions, need to be logged in for all of them.
    $ul->route('/create')->name('admin_create_song_link')->via('GET', 'POST')->to(action => 'create');

    # # Admin routes that capture a tag id
    # my $link_action = $ul->under('/:link_id')->to(action => 'capture');

    # # Remove a tag from a song. The tag isn't deleted from the DB
    # # but is disassociated with this song.
    # $link_action->route->name('remove_song_link')->via('DELETE')->to(action => 'remove');

}


sub list {
    my $c = shift;

    # TODO Pagination
    my $table = $c->table('Song::Link::List');

    $c->stash(table => $table);
}

sub create {
    my $c = shift;

    my $song = $c->stash->{song};
    my $form = $c->form('Link::Create', song => $song);
    
    $c->stash(
        form => $form,
    );
    if ($form->process) {
        $c->flash(msg => 'Link added');
        
        # Redirect so that form is reinitialised
        $c->redirect_to('admin_list_song_links', song_id => $song->id);
    }

}

sub capture {
    my $c = shift;

    my $link_id = $c->stash->{link_id};
    if (my $link = $c->schema->resultset('Link')->find($link_id)) {
        $c->stash(link => $link);
        return 1;
    }
    else {
        $c->reply->not_found;
        return undef;
    }
}

sub remove {
    my $c = shift;

    $c->stash->{song}->delete_link($c->stash->{link});

    $c->render(text => '');
}

1;
