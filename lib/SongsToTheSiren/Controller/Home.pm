package SongsToTheSiren::Controller::Home;
use Mojo::Base 'Mojolicious::Controller';

sub add_routes {
    my ($c, $r) = @_;

    $r->get('/')->to('home#front_page')->name('home');
}

sub front_page {
    my $c = shift;

    # If not logged-in, and not in test mode,
    # go to temporary holding front page. 
    # TODO Remove this when we go live.
    if ( $c->app->mode ne 'test' && !exists $c->stash->{auth_user} ) {
        $c->render(template => 'home/holding_front_page');
        return;
    }

    # TODO Add pagination
    my $tags  = $c->schema->resultset('Tag')
        ->search_by_ids($c->param('tags'));

    my $songs = $c->schema->resultset('Song')
        ->home_page_songs($tags)
        ->select_comment_count('approved');

    $c->stash(
        songs => $songs,
        tags  => $tags,
    );
}

1;
