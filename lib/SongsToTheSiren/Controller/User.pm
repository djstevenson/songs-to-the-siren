package SongsToTheSiren::Controller::User;
use utf8;
use Mojo::Base 'Mojolicious::Controller';

sub add_routes {
    my ($c, $r) = @_;

    ## no critic (ValuesAndExpressions::ProhibitLongChainsOfMethodCalls)
    my $u = $r->any('/user')->to(controller => 'user');

    $u->any(['GET', 'POST'] => '/register')->name('register')->to(action => 'register');
    $u->get('/registered')->name('registered')->to(action => 'registered');
    $u->any(['GET', 'POST'] => '/sign_in')->name('sign_in')->to(action => 'sign_in');
    $u->get('/sign_out')->name('sign_out')->to(action => 'sign_out');
    $u->get('/confirmed')->name('confirmed')->to(action => 'confirmed');
    $u->get('/declined')->name('declined')->to(action => 'declined');

    $u->any(['GET', 'POST'] => '/forgot_password')->name('forgot_password')->to(action => 'forgot_password');
    $u->get('/forgot_password/reset_sent')->name('password_reset_sent')->to(action => 'password_reset_sent');
    $u->get('/reset/done')->name('password_reset_done')->to(action => 'password_reset_done');

    $u->any(['GET', 'POST'] => '/forgot_name')->name('forgot_name')->to(action => 'forgot_name');
    $u->get('/forgot_name/reminder_sent')->name('name_reminder_sent')->to(action => 'name_reminder_sent');

    my $user_action = $u->under('/:user_id')->to(action => 'capture');
    $user_action->get('/confirm/:user_key')->name('confirm_registration')->to(action => 'confirm_registration');
    $user_action->get('/decline/:user_key')->name('decline_registration')->to(action => 'decline_registration');
    $user_action->any(['GET', 'POST'] => '/reset/:user_key')->name('password_reset')->to(action => 'password_reset');
    ## use critic
    
    return;
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

    return;
}

sub sign_in {
    my $c = shift;

    # Logout before presenting the sign-in screen
    # TODO Need a shortcut for this
    delete $c->session->{user};
    delete $c->stash->{auth_user};
    delete $c->stash->{admin_user};

    my $form = $c->form('User::SignIn');
    if (my $user = $form->process) {
        $c->session->{user} = $user->id;
        if ($user->admin) {

            # Admin user wants to go do admin index
            $c->redirect_to('admin_home');
        }
        else {
            # Non-admin back to home page
            # TODO Redirect back to where we pressed 'sign-in'
            $c->redirect_to('home');
        }
    }
    else {
        $c->stash(form => $form);
    }

    return;
}

sub sign_out {
    my $c = shift;

    delete $c->session->{user};
    $c->redirect_to('home');

    return;
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

    return;
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

    return;
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

    my $user     = $c->stash->{target_user};
    my $user_key = $c->stash->{user_key};
    return $c->reply->not_found unless $user->confirm_registration($user_key);

    $c->flash(msg => 'Signup confirmed');
    $c->redirect_to('confirmed');

    return;
}

sub decline_registration {
    my $c = shift;

    my $user     = $c->stash->{target_user};
    my $user_key = $c->stash->{user_key};
    return $c->reply->not_found unless $user->decline_registration($user_key);

    $c->flash(msg => 'Signup declined - your details are deleted');
    $c->redirect_to('declined');

    return;
}

sub password_reset {
    my $c = shift;

    my $user_key    = $c->stash->{user_key};
    my $target_user = $c->stash->{target_user};

    return $c->reply->not_found unless $target_user->check_key('password_reset', $user_key);

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

    return;
}
1;
