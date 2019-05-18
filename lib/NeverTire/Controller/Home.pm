package NeverTire::Controller::Home;
use Mojo::Base 'Mojolicious::Controller';

sub add_routes {
    my ($c, $r) = @_;

    $r->get('/')->to('home#front_page')->name('home');
}

sub default_action {
    my $c = shift;

    # $c->stash(template => 'home');
}

1;
