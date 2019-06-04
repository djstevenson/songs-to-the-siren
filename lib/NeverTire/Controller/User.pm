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
    $u->route('/declined')->name('declined')->via('GET')->to(action => 'declined');

    # Actions that require a user_id to act on that don't need to be logged-in
    # e.g. registration confirmation/declination functions
    my $user_action = $u->under('/:user_id')->to(action => 'capture');
    $user_action->get('/decline/:user_key')->name('decline_registration')->via('GET')->to(action => 'decline_registration');
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


# Below are actions that require a user capture. The stash contains 'user'
# which will be the logged-in person.  BUT the target of this action may be a
# different user (e.g. admin is changing some other punter's details). So,
# this captured user is saved in the stash as 'target_user'.

sub capture {
    my $c = shift;

    my $user_id = $c->stash->{user_id};
    if (my $target_user = $c->schema->resultset('User')->find($user_id)) {
        $c->stash(target_user => $target_user);
        return 1;
    }
    else {
        $c->reply->not_found;
        return undef;
    }
}

sub decline_registration {
    my $c = shift;

    my $user = $c->stash->{target_user};
    my $user_key = $c->stash->{user_key};
    return $c->reply->not_found
        unless $user->decline_registration($user_key);

    $c->flash(msg => 'Registration declined - your details are deleted');
    $c->redirect_to('declined');
}


1;
