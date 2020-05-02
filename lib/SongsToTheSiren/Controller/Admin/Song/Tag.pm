package SongsToTheSiren::Controller::Admin::Song::Tag;
use Mojo::Base 'Mojolicious::Controller';

sub add_routes {
    my ($c, $song_action) = @_;

    my $u = $song_action->require_admin->any('/tag')->to(controller => 'admin-song-tag');

    # Actions that do not capture a tag_id
    $u->route('/edit')->name('admin_edit_song_tags')->via('GET', 'POST')->to(action => 'edit');

    # Actions that DO capture a tag_id
    my $tag_action = $u->under('/:tag_id')->to(action => 'capture');

    # Remove a tag from a song
    $tag_action->route->name('admin_delete_song_tag')->via('DELETE')->to(action => 'delete');

}


sub edit {
    my $c = shift;

    my $song = $c->stash->{song};
    my $form = $c->form('Tag::Create', song => $song);
    
    my $all_tags_rs = $c->schema->resultset('Tag')
        ->by_name
        ->fetch_counts;

    $c->stash(
        song_tags  => [ $song->tags->all ],
        other_tags => [ $all_tags_rs->all ],
        form       => $form,
    );
    if ($form->process) {
        $c->flash(msg => 'Tag added');
        
        # Redirect so that form is reinitialised
        $c->redirect_to('admin_edit_song_tags', song_id => $song->id);
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

    my $tag = $c->stash->{tag};
    $c->stash->{song}->delete_tag($tag);

    $c->render(text => '');
}

1;
