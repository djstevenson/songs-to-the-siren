package NeverTire::Controller::Admin::Song::Link;
use Mojo::Base 'Mojolicious::Controller';

sub add_routes {
    my ($c, $routes) = @_;

    my $ul = $routes->{admin_song_link} ->any('/link')->to(controller => 'Admin::Song::Link');

    $ul->route('/list')->name('admin_list_song_links')->via('GET')->to(action => 'list');

    # These are admin functions, need to be logged in for all of them.
    $ul->route('/create')->name('admin_create_song_link')->via('GET', 'POST')->to(action => 'create');

    # # Admin routes that capture a tag id
    my $link_action = $ul->under('/:link_id')->to(action => 'capture');

    # TODO GET/DELETE rather than GET/POST?
    $link_action->route('/edit')->name('admin_edit_song_link')->via('GET', 'POST')->to(action => 'edit');
    $link_action->route('/delete')->name('admin_delete_song_link')->via('GET', 'POST')->to(action => 'delete');

}


sub list {
    my $c = shift;

    # TODO Pagination
    my $song = $c->stash->{song};
    my $table = $c->table('Song::Link::List', song => $song);

    $c->stash(table => $table);
}

sub create {
    my $c = shift;

    my $song = $c->stash->{song};
    my $form = $c->form('Link::Create', song => $song);
    
    if ($form->process) {
        $c->flash(msg => 'Link added');
        
        # Redirect so that form is reinitialised
        $c->redirect_to('admin_list_song_links', song_id => $song->id);
    }
    else {
        $c->stash(form => $form);
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

sub edit {
    my $c = shift;

    my $song = $c->stash->{song};
    my $link = $c->stash->{link};
    my $form = $c->form('Link::Edit', song => $song, link => $link);
    
    if ($form->process) {
        $c->flash(msg => 'Link edited');
        
        # Redirect so that form is reinitialised
        $c->redirect_to('admin_list_song_links', song_id => $song->id);
    }
    else {
            $c->stash(form => $form);
    }
}

sub delete {
    my $c = shift;

    my $song = $c->stash->{song};
    my $link = $c->stash->{link};
    my $form = $c->form('Link::Delete', song => $song, link => $link);

    if (my $action = $form->process) {
        $c->flash(msg => $action);
        $c->redirect_to('admin_list_song_links', song_id => $song->id);
    }
    else {
        $c->stash(form => $form);
    }
}

1;
