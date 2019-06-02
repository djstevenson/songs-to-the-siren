package NeverTire::Controller::Song;
use Mojo::Base 'Mojolicious::Controller';

use NeverTire::Controller::Song::Tag;

sub add_routes {
    my ($c, $routes) = @_;

    my $ul = $routes->{admin} ->any('/song')->to(controller => 'song');

    # These are admin functions, need to be logged in for all of them.
    $ul->route('/list')->name('list_songs')->via('GET')->to(action => 'list');
    $ul->route('/create')->name('create_song')->via('GET', 'POST')->to(action => 'create');

    # Admin routes that capture a song id
    my $song_action = $ul->under('/:song_id')->to(action => 'capture');

    # TODO Later, add POST cos we'll want a confirmation form
    #      and possibly allowing a future pub date
    $song_action->route('/show')->name('show_song')->via('GET')->to(action => 'show');
    $song_action->route('/hide')->name('hide_song')->via('GET')->to(action => 'hide');
    $song_action->route('/edit')->name('edit_song')->via('GET', 'POST')->to(action => 'edit');
    # Method=DELETE?
    $song_action->route('/delete')->name('delete_song')->via('GET', 'POST')->to(action => 'delete');

    my $tag_controller = NeverTire::Controller::Song::Tag->new;
    $routes->{song} = $song_action;
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

    my $song_id = $c->stash->{song_id};
    if (my $song = $c->schema->resultset('Song')->find($song_id)) {
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



1;
