package NeverTire::Controller::Song;
use Mojo::Base 'Mojolicious::Controller';

use NeverTire::Controller::Song::Comment;
use NeverTire::Controller::Song::Link;
use NeverTire::Controller::Song::Tag;

sub add_routes {
    my ($c, $r) = @_;

    my $u = $r->any('/song')->to(controller => 'song');
    my $a = $u->require_admin;

    # Routes that do not capture a song id
    $a->route('/list')->name('list_songs')->via('GET')->to(action => 'list');
    $a->route('/create')->name('create_song')->via('GET', 'POST')->to(action => 'create');

    # Routes that capture a song id
    my $song_action_u = $u->under('/:song_id')->to(action => 'capture');
    my $song_action_a = $a->under('/:song_id')->to(action => 'capture');

    $song_action_u->route('/view')->name('view_song')->via('GET')->to(action => 'view');
    $song_action_a->route('/publish')->name('publish_song')->via('GET')->to(action => 'publish');
    $song_action_a->route('/unpublish')->name('unpublish_song')->via('GET')->to(action => 'unpublish');
    $song_action_a->route('/edit')->name('edit_song')->via('GET', 'POST')->to(action => 'edit');
    # Method=DELETE?
    $song_action_a->route('/delete')->name('delete_song')->via('GET', 'POST')->to(action => 'delete');

    NeverTire::Controller::Song::Comment ->new ->add_routes($song_action_u);
    NeverTire::Controller::Song::Link    ->new ->add_routes($song_action_u);
    NeverTire::Controller::Song::Tag     ->new ->add_routes($song_action_u);
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

    my $table = $c->table('Song::List');

    $c->stash(table => $table);
}

sub capture {
    my $c = shift;

    # Fetch the full song data, returning 404
    # if it doesn't exist.
    # Check that it's published, unless
    # we're admin, in which case we don't care

    my $song_id = $c->stash->{song_id};
    my $rs = $c->schema->resultset('Song');
    my $admin = exists $c->stash->{admin_user};
    if (my $song = $rs->full_song_data($song_id, $admin)) {
        $c->stash(song => $song);
    }
    else {
        $c->reply->not_found;
        return undef;
    }

    return 1;
}


sub view {
    my $c = shift;

    my $song = $c->stash->{song};
    my $admin = exists $c->stash->{admin_user};

    $c->stash(
        links  => $song->get_links,
        forest => $song->get_comment_forest($admin),
    );
}

sub publish {
    my $c = shift;

    $c->stash->{song}->show;

    $c->redirect_to('list_songs');
}

sub unpublish {
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
