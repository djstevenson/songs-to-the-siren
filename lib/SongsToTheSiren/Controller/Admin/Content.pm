package SongsToTheSiren::Controller::Admin::Content;
use Mojo::Base 'Mojolicious::Controller';

sub add_routes {
    my ($c, $r) = @_;

    # $r already has 'require_admin' check applied
    my $a = $r->any('/content')->to(controller => 'admin-content');

    # Capturing a song name
    my $content_action_a = $a->under('/:name')->to(action => 'capture');

    # Admin routes, no capture:
    $a->route('/list')->name('admin_list_content')->via('GET')->to(action => 'list');
    $a->route('/create')->name('admin_create_content')->via('GET', 'POST')->to(action => 'create');

    # Admin content, with a capture
    $content_action_a->route('/edit')->name('admin_edit_content')->via('GET', 'POST')->to(action => 'edit');

    # Method=DELETE?
    $content_action_a->route('/delete')->name('admin_delete_content')->via('GET', 'POST')->to(action => 'delete');

}

sub create {
    my $c = shift;

    my $form = $c->form('Content::Edit');
    if ($form->process) {
        $c->flash(msg => 'New country created') if $form->action eq 'created';
        $c->redirect_to('admin_list_content');
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
    my $rs   = $c->schema->resultset('Content');
    if (my $content = $rs->find($name)) {
        $c->stash(content => $content);
    }
    else {
        $c->reply->not_found;
        return undef;
    }

    return 1;
}


sub edit {
    my $c = shift;

    my $content = $c->stash->{content};
    my $form    = $c->form('Content::Edit', content => $content);

    if ($form->process) {
        $c->flash(msg => 'Content updated') if $form->action eq 'updated';
        $c->redirect_to('admin_list_content');
    }
    else {
        $c->stash(form => $form);
    }
}

sub delete {
    my $c = shift;

    my $form = $c->form('Content::Delete', content => $c->stash->{content});
    if (my $action = $form->process) {
        $c->flash(msg => 'Content deleted') if $form->action eq 'deleted';
        $c->redirect_to('admin_list_content');
    }
    else {
        $c->stash(form => $form);
    }
}


1;
