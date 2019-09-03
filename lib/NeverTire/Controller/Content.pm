package NeverTire::Controller::Content;
use Mojo::Base 'Mojolicious::Controller';

sub add_routes {
    my ($c, $r) = @_;

    my $u = $r->any('/content')->to(controller => 'content');
    my $a = $u->require_admin;

    # Capturing a song name
    my $content_action_u = $u->under('/:name')->to(action => 'capture');
    my $content_action_a = $a->under('/:name')->to(action => 'capture');

    # Non-admin content, with a capture
    $content_action_u->route('/view')->name('view_content')->via('GET')->to(action => 'view');

    # Admin routes, no capture:
    $a->route('/list')->name('list_content')->via('GET')->to(action => 'list');
    $a->route('/create')->name('create_content')->via('GET', 'POST')->to(action => 'create');

    # Admin content, with a capture
    $content_action_a->route('/edit')->name('edit_content')->via('GET', 'POST')->to(action => 'edit');

    # Method=DELETE?
    $content_action_a->route('/delete')->name('delete_content')->via('GET', 'POST')->to(action => 'delete');

}

sub create {
    my $c = shift;

    my $form = $c->form('Content::Create');
    if ($form->process) {
        $c->flash(msg => 'Content created');

        $c->redirect_to('list_content');
    }
    else {
        $c->stash(form => $form);
    }
}

sub list {
    my $c = shift;

    my $table = $c->table('Content::List');

    $c->stash(table => $table);
}

sub capture {
    my $c = shift;

    my $name = $c->stash->{name};
    my $rs = $c->schema->resultset('Content');
    if ( my $content = $rs->find($name) ) {
        $c->stash( content => $content );
    }
    else {
        $c->reply->not_found;
        return undef;
    }

    return 1;
}


sub view {}

sub edit {
    my $c = shift;

    my $content = $c->stash->{content};
    my $form = $c->form('Content::Edit', content => $content);
    
    if ($form->process) {
        $c->flash(msg => 'Page updated');

        $c->redirect_to('list_content');
    }
    else {
        $c->stash(form => $form);
    }
}

sub delete {
    my $c = shift;

    my $form = $c->form('Content::Delete', content => $c->stash->{content});
    if (my $action = $form->process) {
        $c->flash(msg => $action);
        $c->redirect_to('list_content');
    }
    else {
        $c->stash(form => $form);
    }
}


1;
