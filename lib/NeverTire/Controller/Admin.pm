package NeverTire::Controller::Admin;
use Mojo::Base 'Mojolicious::Controller';

use NeverTire::Controller::Admin::Song;
use NeverTire::Controller::Admin::Content;

sub add_routes {
    my ($c, $r) = @_;

    my $a = $r->any('/admin')->require_admin;
    
    $a->get('/')->name('admin_home')->to('admin#home');

    NeverTire::Controller::Admin::Song    ->new ->add_routes($a);
    NeverTire::Controller::Admin::Content ->new ->add_routes($a);
}

1;
