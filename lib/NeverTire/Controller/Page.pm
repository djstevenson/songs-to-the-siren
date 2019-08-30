package NeverTire::Controller::Page;
use Mojo::Base 'Mojolicious::Controller';

sub add_routes {
    my ($c, $r) = @_;

    my $u = $r->any('/page')->to(controller => 'page');
    my $a = $u->require_admin;

    # Capturing a song name
    my $page_action_u = $u->under('/:name')->to(action => 'capture');
    my $page_action_a = $a->under('/:name')->to(action => 'capture');

    # Non-admin pages, with a capture
    $page_action_u->route('/view')->name('view_page')->via('GET')->to(action => 'view');

    # Admin routes, no capture:
    $a->route('/list')->name('list_pages')->via('GET')->to(action => 'list');
    $a->route('/create')->name('create_page')->via('GET', 'POST')->to(action => 'create');

    # Admin pages, with a capture
    $page_action_a->route('/edit')->name('edit_page')->via('GET', 'POST')->to(action => 'edit');

    # Method=DELETE?
    # $song_action_a->route('/delete')->name('delete_song')->via('GET', 'POST')->to(action => 'delete');

}

sub create {
    my $c = shift;

    my $form = $c->form('Page::Create');
    if ($form->process) {
        $c->flash(msg => 'Page created');

        $c->redirect_to('list_pages');
    }
    else {
        $c->stash(form => $form);
    }
}

sub list {
    my $c = shift;

    my $table = $c->table('Page::List');

    $c->stash(table => $table);
}

sub capture {
    my $c = shift;

    my $name = $c->stash->{name};
    my $rs = $c->schema->resultset('Page');
    if ( my $page = $rs->find_by_name($name) ) {
        $c->stash( page => $page );
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

    my $page = $c->stash->{page};
    my $form = $c->form('Page::Edit', page => $page);
    
    if ($form->process) {
        $c->flash(msg => 'Page updated');

        $c->redirect_to('list_pages');
    }
    else {
        $c->stash(form => $form);
    }
}

# sub delete {
#     my $c = shift;

#     my $form = $c->form('Song::Delete', song => $c->stash->{song});
#     if (my $action = $form->process) {
#         $c->flash(msg => $action);
#         $c->redirect_to('list_songs');
#     }
#     else {
#         $c->stash(form => $form);
#     }
# }


1;
