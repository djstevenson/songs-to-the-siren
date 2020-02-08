package SongsToTheSiren::Controller::Admin::Country;
use Mojo::Base 'Mojolicious::Controller';

sub add_routes {
    my ($c, $r) = @_;

    # $r already has 'require_admin' check applied
    my $a = $r->any('/country')->to(controller => 'admin-country');

    # Capturing a country id
    my $country_action_a = $a->under('/:country_id')->to(action => 'capture');

    # Admin routes, no capture:
    $a->route('/list')->name('admin_list_countries')->via('GET')->to(action => 'list');
    $a->route('/create')->name('admin_create_country')->via('GET', 'POST')->to(action => 'create');

    # Admin actions, with a capture
    $country_action_a->route('/edit')->name('admin_edit_country')->via('GET', 'POST')->to(action => 'edit');

    # # Method=DELETE?
    $country_action_a->route('/delete')->name('admin_delete_country')->via('GET', 'POST')->to(action => 'delete');

}

sub create {
    my $c = shift;

    my $form = $c->form('Country::Edit');
    if ($form->process) {
        $c->flash(msg => 'Country created') if $form->action eq 'created';

        $c->redirect_to('admin_list_countries');
    }
    else {
        $c->stash(form => $form);
    }
}

sub list {
    my $c = shift;

    my $table = $c->table('Country::List');

    $c->stash(table => $table);
}

sub capture {
    my $c = shift;

    my $name = $c->stash->{country_id};
    my $rs = $c->schema->resultset('Country');
    if ( my $country = $rs->find($name) ) {
        $c->stash( country => $country );
    }
    else {
        $c->reply->not_found;
        return undef;
    }

    return 1;
}


sub edit {
    my $c = shift;

    my $country = $c->stash->{country};
    my $form = $c->form('Country::Edit', country => $country);
    
    if ($form->process) {
        $c->flash(msg => 'Country updated') if $form->action eq 'updated';

        $c->redirect_to('admin_list_countries');
    }
    else {
        $c->stash(form => $form);
    }
}

sub delete {
    my $c = shift;

    my $form = $c->form('Country::Delete', country => $c->stash->{country});
    if (my $action = $form->process) {
        $c->flash(msg => 'Country deleted') if $form->action eq 'deleted';
        $c->redirect_to('admin_list_countries');
    }
    else {
        $c->stash(form => $form);
    }
}


1;
