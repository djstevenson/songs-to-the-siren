package NeverTire::Controller::User;
use Mojo::Base 'Mojolicious::Controller';

# $r  = routes
# $rl = routes for which you need to be logged-in

sub add_routes {
    my ($c, $r, $rl) = @_;

    my $u  = $r ->any('/user')->to(controller => 'user');
    my $ul = $rl->any('/user')->to(controller => 'user');

    # Don't need to be logged-in for these:
    $u->route('/login')->name('login')->via('GET', 'POST')->to(action => 'login');
    $u->route('/logout')->name('logout')->via('GET')->to(action => 'logout');
}

sub login {
    my $c = shift;

    my $form = $c->form('User::Login');
    if (my $user = $form->process) {
        $c->session->{user} = $user->id;
        $c->redirect_to('list_songs');
    }
    else {
        $c->stash(form => $form);
    }
}

sub logout {
    my $c = shift;

    delete $c->session->{user};
    $c->redirect_to('home');
}

1;
