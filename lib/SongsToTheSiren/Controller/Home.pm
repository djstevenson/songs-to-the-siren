package SongsToTheSiren::Controller::Home;
use Mojo::Base 'Mojolicious::Controller';

sub add_routes {
    my ($c, $r) = @_;

    $r->get('/')->to('home#front_page')->name('home');
}

sub front_page {
    my $c = shift;

    # TODO Add pagination
    my $tags = $c->schema->resultset('Tag')->search_by_ids($c->param('tags'));

    my $songs = $c->schema->resultset('Song')->home_page_songs($tags)->select_comment_count('approved');

    $c->stash(songs => $songs, tags => $tags,);
}

1;
