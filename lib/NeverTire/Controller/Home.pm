package NeverTire::Controller::Home;
use Mojo::Base 'Mojolicious::Controller';

sub add_routes {
    my ($c, $routes) = @_;

    $routes->{all} ->get('/')->to('home#front_page')->name('home');
}

sub front_page {
    my $c = shift;

    # TODO Add pagination
    my $tag_id = $c->param('tag');
    my $songs = $c->schema->resultset('Song')
        ->home_page_songs($tag_id);
        
    $c->stash(songs => $songs);
}

1;
