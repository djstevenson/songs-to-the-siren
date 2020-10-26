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
    my $tag = $c->schema->resultset('Tag')->find($c->param('tag'));

    my $songs_rs = $c->schema->resultset('Song');
    my $songs = $songs_rs->home_page_songs($tag)->select_comment_count('approved');

    $c->stash(songs => $songs, tag => $tag);

    return;
}

1;
