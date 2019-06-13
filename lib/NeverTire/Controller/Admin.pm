package NeverTire::Controller::Admin;
use Mojo::Base 'Mojolicious::Controller';

use NeverTire::Controller::Admin::Song;

sub add_routes {
    my ($c, $routes) = @_;

    $routes->{admin_song} = $routes->{admin} ->any('/admin')->to(action => 'admin');

    my $admin_song_controller = NeverTire::Controller::Admin::Song->new; 
    $admin_song_controller->add_routes($routes);
}

sub admin {}

1;
