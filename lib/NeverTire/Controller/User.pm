package NeverTire::Controller::User;
use Mojo::Base 'Mojolicious::Controller';

sub add_routes {
    my ($c, $routes) = @_;

    my $u  = $routes->{all} ->any('/user')->to(controller => 'user');

    # Don't need to be logged-in for these:
    $u->route('/register')->name('register')->via('GET', 'POST')->to(action => 'register');
    $u->route('/registered')->name('registered')->via('GET')->to(action => 'registered');
    $u->route('/login')->name('login')->via('GET', 'POST')->to(action => 'login');
    $u->route('/logout')->name('logout')->via('GET')->to(action => 'logout');
}

sub register {
    my $c = shift;

    my $form = $c->form('User::Register');
    if (my $user = $form->process) {
        $c->flash(msg => 'Registered - watch out for confirmation email');
        # TODO PM to admin? To deal with reg issues?
        $c->redirect_to('registered');
    }
    else {
        $c->stash(form => $form);
    }
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
