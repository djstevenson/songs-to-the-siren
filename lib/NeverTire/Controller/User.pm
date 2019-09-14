package NeverTire::Controller::User;
use Mojo::Base 'Mojolicious::Controller';

sub add_routes {
    my ($c, $r) = @_;

    my $u = $r->any('/user')->to(controller => 'user');

    $u->route('/register')->name('register')->via('GET', 'POST')->to(action => 'register');
    $u->route('/registered')->name('registered')->via('GET')->to(action => 'registered');
    $u->route('/login')->name('login')->via('GET', 'POST')->to(action => 'login');
    $u->route('/logout')->name('logout')->via('GET')->to(action => 'logout');
    $u->route('/confirmed')->name('confirmed')->via('GET')->to(action => 'confirmed');
    $u->route('/declined')->name('declined')->via('GET')->to(action => 'declined');

    $u->route('/forgot_password')->name('forgot_password')->via('GET', 'POST')->to(action => 'forgot_password');
    $u->route('/forgot_password/reset_sent')->name('password_reset_sent')->via('GET')->to(action => 'password_reset_sent');
    $u->route('/reset/done')->name('password_reset_done')->via('GET')->to(action => 'password_reset_done');

    $u->route('/forgot_name')->name('forgot_name')->via('GET', 'POST')->to(action => 'forgot_name');
    $u->route('/forgot_name/reminder_sent')->name('name_reminder_sent')->via('GET')->to(action => 'name_reminder_sent');

    my $user_action = $u->under('/:user_id')->to(action => 'capture');
    $user_action->get('/confirm/:user_key')->name('confirm_registration')->via('GET')->to(action => 'confirm_registration');
    $user_action->get('/decline/:user_key')->name('decline_registration')->via('GET')->to(action => 'decline_registration');
    $user_action->get('/reset/:user_key')->name('password_reset')->via('GET', 'POST')->to(action => 'password_reset');
}

sub register {
    my $c = shift;

    my $form = $c->form('User::Register');
    if (my $user = $form->process) {
        $c->flash(msg => 'User created - watch out for confirmation email');
        $c->redirect_to('registered');
    }
    else {
        $c->stash(form => $form);
    }
}

sub login {
    my $c = shift;

    # Logout before presenting the login screen
    # TODO Need a shortcut for this
    delete $c->session->{user};
    delete $c->stash->{auth_user};
    delete $c->stash->{admin_user};

    my $form = $c->form('User::Login');
    if (my $user = $form->process) {
        $c->session->{user} = $user->id;
        if ($user->admin) {
            # Admin will want to go to song edit page
            $c->redirect_to('admin_list_songs');
        }
        else {
            # Non-admin back to home page
            # TODO Redirect back to where we pressed 'login'
            $c->redirect_to('home');
        }
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

sub forgot_name {
    my $c = shift;

    my $form = $c->form('User::ForgotName');
    if (my $user = $form->process) {
        $c->flash(msg => 'Name reminder email sent');
        $c->redirect_to('name_reminder_sent');
    }
    else {
        $c->stash(form => $form);
    }
}

sub forgot_password {
    my $c = shift;

    my $form = $c->form('User::ForgotPassword');
    if (my $user = $form->process) {
        $c->flash(msg => 'Password reset email sent');
        $c->redirect_to('password_reset_sent');
    }
    else {
        $c->stash(form => $form);
    }
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

sub confirm_registration {
    my $c = shift;

    my $user = $c->stash->{target_user};
    my $user_key = $c->stash->{user_key};
    return $c->reply->not_found
        unless $user->confirm_registration($user_key);

    $c->flash(msg => 'Signup confirmed');
    $c->redirect_to('confirmed');
}

sub decline_registration {
    my $c = shift;

    my $user = $c->stash->{target_user};
    my $user_key = $c->stash->{user_key};
    return $c->reply->not_found
        unless $user->decline_registration($user_key);

    $c->flash(msg => 'Signup declined - your details are deleted');
    $c->redirect_to('declined');
}

sub password_reset {
    my $c = shift;

    my $user_key    = $c->stash->{user_key};
    my $target_user = $c->stash->{target_user};

    return $c->reply->not_found
        unless $target_user->check_key('password_reset', $user_key);

    my $form = $c->form('User::ResetPassword');
    if ($form->process) {
        $target_user->update_password($form->find_field('password')->value);

        $c->flash(msg => 'Your password has been reset');
        $c->redirect_to('password_reset_done');
        # TODO Send an email notification when password is updated?
    }
    else {
        $c->stash(form => $form);
    }
}
1;
