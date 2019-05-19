package NeverTire::Controller::Song;
use Mojo::Base 'Mojolicious::Controller';

# $r  = routes
# $rl = routes for which you need to be logged-in

sub add_routes {
    my ($c, $r, $rl) = @_;

    my $ul = $rl->any('/song')->to(controller => 'song');

    # These are admin functions, need to be logged in for all of them.
    $ul->route('/list')->name('list_songs')->via('GET')->to(action => 'list');
}

sub list {
    my $c = shift;

    # TODO Pagination
    my $songs = $c->schema
        ->resultset('Song')
        ->select_metadata
        ->by_pubdate;

    $c->stash(songs => $songs);
}


1;
