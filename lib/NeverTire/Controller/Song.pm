package NeverTire::Controller::Song;
use Mojo::Base 'Mojolicious::Controller';

use NeverTire::Controller::Song::Tag;

sub add_routes {
    my ($c, $routes) = @_;

    my $ul = $routes->{admin} ->any('/song')->to(controller => 'song');
    my $u  = $routes->{all}   ->any('/song')->to(controller => 'song');
    
    # These are admin functions, need to be logged in for all of them.
    $ul->route('/list')->name('list_songs')->via('GET')->to(action => 'admin_list');
    $ul->route('/create')->name('create_song')->via('GET', 'POST')->to(action => 'admin_create');

    # Non-admin routes that capture a song id
    my $song_action = $u->under('/:song_id')->to(action => 'capture');
    $song_action->route('/view')->name('view_song')->via('GET')->to(action => 'view');


    # Admin routes that capture a song id
    my $admin_song_action = $ul->under('/:song_id')->to(action => 'capture');

    # TODO Later, add POST cos we'll want a confirmation form
    #      and possibly allowing a future pub date
    #
    # TODO Move admin functions into separate controller
    $admin_song_action->route('/show')->name('admin_show_song')->via('GET')->to(action => 'admin_show');
    $admin_song_action->route('/hide')->name('admin_hide_song')->via('GET')->to(action => 'admin_hide');
    $admin_song_action->route('/edit')->name('admin_edit_song')->via('GET', 'POST')->to(action => 'admin_edit');
    # Method=DELETE?
    $admin_song_action->route('/delete')->name('admin_delete_song')->via('GET', 'POST')->to(action => 'admin_delete');

    my $tag_controller = NeverTire::Controller::Song::Tag->new;
    $routes->{admin_song} = $admin_song_action;
    $tag_controller->add_routes($routes);
}

sub admin_create {
    my $c = shift;

    my $form = $c->form('Song::Create');
    if ($form->process) {
        $c->flash(msg => 'Song created');

        $c->redirect_to('list_songs');
    }
    else {
        $c->stash(form => $form);
    }
}

sub admin_list {
    my $c = shift;

    # TODO Pagination
    my $table = $c->table('Song::List');

    $c->stash(table => $table);
}

sub capture {
    my $c = shift;

    # Fetch the song to check it exists. The view
    # method will then fetch it again to get all
    # the data it needs.
    # TODO Fix this with separate controllers for 
    # admin and non-admin actions.

    my $song_id = $c->stash->{song_id};
    my $rs = $c->schema->resultset('Song');
    if (my $song = $rs->find($song_id)) {
        $c->stash(song => $song);
    }
    else {
        $c->reply->not_found;
        return undef;
    }

    return 1;
}

sub admin_show {
    my $c = shift;

    $c->stash->{song}->show;

    $c->redirect_to('list_songs');
}

sub admin_hide {
    my $c = shift;

    $c->stash->{song}->hide;

    $c->redirect_to('list_songs');
}

sub admin_edit {
    my $c = shift;

    my $song_id = $c->stash->{song_id};
    
    # We already know song exists
    my $rs = $c->schema->resultset('Song');
    my $form = $c->form('Song::Edit', song => $rs->find($song_id));
    if ($form->process) {
        $c->flash(msg => 'Song updated');

        $c->redirect_to('list_songs');
    }
    else {
        $c->stash(form => $form);
    }
}

sub admin_delete {
    my $c = shift;

    my $form = $c->form('Song::Delete', song => $c->stash->{song});
    if (my $action = $form->process) {
        $c->flash(msg => $action);
        $c->redirect_to('list_songs');
    }
    else {
        $c->stash(form => $form);
    }
}

sub view {
    my $c = shift;

    my $song_id = $c->stash->{song_id};

    # We already know song exists
    my $rs = $c->schema->resultset('Song');
    $c->stash(song => $rs->full_song_data($song_id));
}

1;
