package NeverTire::Controller::Home;
use Mojo::Base 'Mojolicious::Controller';

sub default_action {
    my $c = shift;

    $c->render(text => 'Hello World!');
}

1;
