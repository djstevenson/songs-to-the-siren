package NeverTire::Controller::Admin::Song;
use Mojo::Base 'Mojolicious::Controller';

use NeverTire::Controller::Admin::Song::Tag;
use NeverTire::Controller::Admin::Song::Link;

sub add_routes {
    my ($c, $routes) = @_;

    my $ul = $routes->{admin_song} ->any('/song')->to(controller => 'Admin::Song');
    
    # These are admin functions, need to be logged in for all of them.
    $ul->route('/list')->name('list_songs')->via('GET')->to(action => 'list');
    $ul->route('/create')->name('create_song')->via('GET', 'POST')->to(action => 'create');

    # Admin routes that capture a song id
    my $admin_song_action = $ul->under('/:song_id')->to(action => 'capture');

    # TODO Later, add POST cos we'll want a confirmation form
    #      and possibly allowing a future pub date
    #
    $admin_song_action->route('/show')->name('admin_show_song')->via('GET')->to(action => 'show');
    $admin_song_action->route('/hide')->name('admin_hide_song')->via('GET')->to(action => 'hide');
    $admin_song_action->route('/edit')->name('admin_edit_song')->via('GET', 'POST')->to(action => 'edit');
    # Method=DELETE?
    $admin_song_action->route('/delete')->name('admin_delete_song')->via('GET', 'POST')->to(action => 'delete');

    # Routes for editing tags
    my $tag_controller = NeverTire::Controller::Admin::Song::Tag->new;
    $routes->{admin_song_tag} = $admin_song_action;
    $tag_controller->add_routes($routes);

    # Routes for editing links
    my $link_controller = NeverTire::Controller::Admin::Song::Link->new;
    $routes->{admin_song_link} = $admin_song_action;
    $link_controller->add_routes($routes);
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
    
    # We already know song exists
    my $rs = $c->schema->resultset('Song');
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

    my $form = $c->form('Song::Delete', song => $c->stash->{song});
    if (my $action = $form->process) {
        $c->flash(msg => $action);
        $c->redirect_to('list_songs');
    }
    else {
        $c->stash(form => $form);
    }
}


1;
