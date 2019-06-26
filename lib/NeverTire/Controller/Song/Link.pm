package NeverTire::Controller::Song::Link;
use Mojo::Base 'Mojolicious::Controller';

sub add_routes {
    my ($c, $song_action) = @_;

    my $u = $song_action->any('/link')->to(controller => 'Song::Link');

    # Admin routes that do not capture a link id
    $u->route('/list')->name('list_song_links')->via('GET')->to(action => 'list');
    $u->route('/create')->name('create_song_link')->via('GET', 'POST')->to(action => 'create');

    # Admin routes that capture a link id
    my $link_action = $u->under('/:link_id')->to(action => 'capture');
    $link_action->route('/edit')->name('edit_song_link')->via('GET', 'POST')->to(action => 'edit');
    $link_action->route('/delete')->name('delete_song_link')->via('GET', 'POST')->to(action => 'delete'); # DELETE method?
}


sub list {
    my $c = shift;

    $c->assert_admin;

    my $song = $c->stash->{song};
    my $table = $c->table('Song::Link::List', song => $song);

    $c->stash(table => $table);
}

sub create {
    my $c = shift;

    $c->assert_admin;
    
    my $song = $c->stash->{song};
    my $form = $c->form('Link::Create', song => $song);
    
    if ($form->process) {
        $c->flash(msg => 'Link added');
        
        # Redirect so that form is reinitialised
        $c->redirect_to('list_song_links', song_id => $song->id);
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

    $c->assert_admin;
    
    my $song = $c->stash->{song};
    my $link = $c->stash->{link};
    my $form = $c->form('Link::Edit', song => $song, link => $link);
    
    if ($form->process) {
        $c->flash(msg => 'Link edited');
        
        # Redirect so that form is reinitialised
        $c->redirect_to('list_song_links', song_id => $song->id);
    }
    else {
            $c->stash(form => $form);
    }
}

sub delete {
    my $c = shift;

    $c->assert_admin;
    
    my $song = $c->stash->{song};
    my $link = $c->stash->{link};
    my $form = $c->form('Link::Delete', song => $song, link => $link);

    if (my $action = $form->process) {
        $c->flash(msg => $action);
        $c->redirect_to('list_song_links', song_id => $song->id);
    }
    else {
        $c->stash(form => $form);
    }
}

1;
