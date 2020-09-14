package SongsToTheSiren::Controller::Home;
use utf8;
use Mojo::Base 'Mojolicious::Controller';

sub add_routes {
    my ($c, $r) = @_;

    $r->get(q{/})->to('home#front_page')->name('home');
    
    return;
}

sub front_page {
    my $c = shift;

    # TODO Add pagination
    my $tags = $c->schema->resultset('Tag')->search_by_ids($c->param('tags'));

    my $songs_rs = $c->schema->resultset('Song');
    my $songs = $songs_rs->home_page_songs($tags)->select_comment_count('approved');

    $c->stash(songs => $songs, tags => $tags);

    return;
}

1;
