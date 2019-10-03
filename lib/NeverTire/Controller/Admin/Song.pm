package NeverTire::Controller::Admin::Song;
use Mojo::Base 'Mojolicious::Controller';

use NeverTire::Controller::Admin::Song::Comment;
use NeverTire::Controller::Admin::Song::Link;
sub add_routes {
    my ($c, $r) = @_;

    # $r already has 'require_admin' check applied

    my $a = $r->any('song')->to(controller => 'admin-song');

    # Routes that do not capture a song id
    $a->route('/list')->name('admin_list_songs')->via('GET')->to(action => 'list');
    $a->route('/create')->name('admin_create_song')->via('GET', 'POST')->to(action => 'create');

    # # Routes that capture a song id
    my $song_a = $a->under('/:song_id')->to(action => 'capture');

    $song_a->route('/publish')->name('admin_publish_song')->via('GET')->to(action => 'publish');
    $song_a->route('/unpublish')->name('admin_unpublish_song')->via('GET')->to(action => 'unpublish');
    $song_a->route('/edit')->name('admin_edit_song')->via('GET', 'POST')->to(action => 'edit');
    # Method=DELETE?
    $song_a->route('/delete')->name('admin_delete_song')->via('GET', 'POST')->to(action => 'delete');

    NeverTire::Controller::Admin::Song::Comment ->new ->add_routes($song_a);
    NeverTire::Controller::Admin::Song::Link    ->new ->add_routes($song_a);
    # NeverTire::Controller::Admin::Song::Tag     ->new ->add_routes($song_a);
}

sub create {
    my $c = shift;

    my $form = $c->form('Song::Create');
    if ($form->process) {
        $c->flash(msg => 'Song created');

        $c->redirect_to('admin_list_songs');
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

sub publish {
    my $c = shift;

    $c->stash->{song}->show;

    $c->redirect_to('admin_list_songs');
}

sub unpublish {
    my $c = shift;

    $c->stash->{song}->hide;

    $c->redirect_to('admin_list_songs');
}

sub edit {
    my $c = shift;

    my $song = $c->stash->{song};
    my $form = $c->form('Song::Edit', song => $song);
    
    if ($form->process) {
        $c->flash(msg => 'Song updated');

        $c->redirect_to('admin_list_songs');
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
        $c->redirect_to('admin_list_songs');
    }
    else {
        $c->stash(form => $form);
    }
}


1;
