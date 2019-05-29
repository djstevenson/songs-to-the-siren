package NeverTire::Controller::Song::Tag;
use Mojo::Base 'Mojolicious::Controller';

# $rl = base route for '/song/:id' tag admin actions

sub add_routes {
    my ($c, $rl) = @_;

    my $ul = $rl->any('/tag')->to(controller => 'Song::Tag');

    # These are admin functions, need to be logged in for all of them.
    $ul->route('/edit')->name('edit_song_tags')->via('GET')->to(action => 'edit');

    # Admin routes that capture a tag id
    my $tag_action = $ul->under('/:tag_id')->to(action => 'capture');

    # Remove a tag from a song. The tag isn't deleted from the DB
    # but is disassociated with this song.
    $tag_action->route->name('remove_song_tag')->via('DELETE')->to(action => 'remove');

}


sub edit {
    my $c = shift;

    my $tags = $c->stash->{song}->tags;
    $c->stash(tags => [ $tags->all ]);
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

sub remove {
    my $c = shift;

    $c->stash->{song}->song_tags->search({
        tag_id => $c->stash->{tag}->id
    })->delete;

    $c->render(text => '');
}

1;
