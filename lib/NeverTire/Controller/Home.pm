package NeverTire::Controller::Home;
use Mojo::Base 'Mojolicious::Controller';

sub add_routes {
    my ($c, $r) = @_;

    $r->get('/')->to('home#front_page')->name('home');
}

sub front_page {
    my $c = shift;

    # TODO Add pagination
    my $songs = $c->schema->resultset('Song')->home_page_songs;
    $c->stash(songs => $songs);
}

1;
