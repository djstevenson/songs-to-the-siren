package NeverTire::Controller::Song;
use Mojo::Base 'Mojolicious::Controller';

use NeverTire::Controller::Song::Tag;

sub add_routes {
    my ($c, $routes) = @_;

    my $ul = $routes->{admin} ->any('/song')->to(controller => 'song');
    my $u  = $routes->{all}   ->any('/song')->to(controller => 'song');
    
    # These are admin functions, need to be logged in for all of them.
    $ul->route('/list')->name('list_songs')->via('GET')->to(action => 'list');
    $ul->route('/create')->name('create_song')->via('GET', 'POST')->to(action => 'create');

    # Non-admin routes that capture a song id
    my $song_action = $u->under('/:song_id')->to(action => 'capture');
    $song_action->route('/view')->name('view_song')->via('GET')->to(action => 'view');


    # Admin routes that capture a song id
    my $admin_song_action = $ul->under('/:song_id')->to(action => 'capture');

    # TODO Later, add POST cos we'll want a confirmation form
    #      and possibly allowing a future pub date
    $admin_song_action->route('/show')->name('admin_show_song')->via('GET')->to(action => 'show');
    $admin_song_action->route('/hide')->name('admin_hide_song')->via('GET')->to(action => 'hide');
    $admin_song_action->route('/edit')->name('admin_edit_song')->via('GET', 'POST')->to(action => 'edit');
    # Method=DELETE?
    $admin_song_action->route('/delete')->name('admin_delete_song')->via('GET', 'POST')->to(action => 'delete');

    my $tag_controller = NeverTire::Controller::Song::Tag->new;
    $routes->{admin_song} = $admin_song_action;
    $tag_controller->add_routes($routes);
}

sub create {
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

sub list {
    my $c = shift;

    # TODO Pagination
    my $table = $c->table('Song::List');

    $c->stash(table => $table);
}

sub capture {
    my $c = shift;

    # When we fetch the song, get enough data for a full
    # display. The admin actions won't need this, but we
    # don't want the non-admin actions (e.g. view, the 
    # highest volume of action) to have to do another fetch.
    my $song_id = $c->stash->{song_id};
    my $rs = $c->schema->resultset('Song');
    if (my $song = $rs->full_song_data($song_id)) {
        $c->stash(song => $song);
        return 1;
    }
    else {
        $c->reply->not_found;
        return undef;
    }
}

sub show {
    my $c = shift;

    $c->stash->{song}->show;

    $c->redirect_to('list_songs');
}

sub hide {
    my $c = shift;

    $c->stash->{song}->hide;

    $c->redirect_to('list_songs');
}

sub edit {
    my $c = shift;

    my $song = $c->stash->{song};
    my $form = $c->form('Song::Edit', song => $song);
    if ($form->process) {
        $c->flash(msg => 'Song updated');

        $c->redirect_to('list_songs');
    }
    else {
        $c->stash(form => $form);
    }
}

sub delete {
    my $c = shift;

    my $song = $c->stash->{song};
    my $form = $c->form('Song::Delete', song => $song);
    if (my $action = $form->process) {
        $c->flash(msg => $action);
        $c->redirect_to('list_songs');
    }
    else {
        $c->stash(form => $form);
    }
}

sub view {
}

1;
