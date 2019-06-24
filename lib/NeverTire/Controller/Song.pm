package NeverTire::Controller::Song;
use Mojo::Base 'Mojolicious::Controller';

# Controller for NON-ADMIN song things.

use NeverTire::Controller::Song::Comment;

sub add_routes {
    my ($c, $routes) = @_;

    my $u  = $routes->{all}   ->any('/song')->to(controller => 'song');
    my $ul = $routes->{login} ->any('/song')->to(controller => 'song');
    
    # Non-admin routes that capture a song id
    my $song_action = $u->under('/:song_id')->to(action => 'capture');
    $song_action->route('/view')->name('view_song')->via('GET')->to(action => 'view');

    # Routes where we capture a song_id but you need to be logged in
    $routes->{login_song} = $ul->under('/:song_id')->to(action => 'capture');

    my $comment_controller = NeverTire::Controller::Song::Comment->new;
    $comment_controller->add_routes($routes);
}

sub capture {
    my $c = shift;

    # Fetch the full song data, returning 404
    # if it doesn't exist.

    my $song_id = $c->stash->{song_id};
    my $rs = $c->schema->resultset('Song');
    if (my $song = $rs->full_song_data($song_id)) {
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
    $c->stash(
        links  => $song->get_links,
        forest => $song->get_comment_forest,
    );
}

1;
