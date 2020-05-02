package SongsToTheSiren::Controller::Admin;
use Mojo::Base 'Mojolicious::Controller';

use SongsToTheSiren::Controller::Admin::Song;
use SongsToTheSiren::Controller::Admin::Content;

sub add_routes {
    my ($c, $r) = @_;

    my $a = $r->any('/admin')->require_admin;
    
    $a->get('/')->name('admin_home')->to('admin#home');

    SongsToTheSiren::Controller::Admin::Song    ->new ->add_routes($a);
    SongsToTheSiren::Controller::Admin::Content ->new ->add_routes($a);
}

1;
