package SongsToTheSiren::Controller::Admin::Song::Link;
use Mojo::Base 'Mojolicious::Controller';

sub add_routes {
    my ($c, $song_action) = @_;

    my $u = $song_action->require_admin->any('/link')->to(controller => 'admin-song-link');

    # Admin routes that do not capture a link id
    $u->route('/list')->name('admin_list_song_links')->via('GET')->to(action => 'list');
    $u->route('/create')->name('admin_create_song_link')->via('GET', 'POST')->to(action => 'create');

    # Admin routes that capture a link id
    my $link_action = $u->under('/:link_id')->to(action => 'capture');
    $link_action->route('/edit')->name('admin_edit_song_link')->via('GET', 'POST')->to(action => 'edit');
    $link_action->route('/delete')->name('admin_delete_song_link')->via('GET', 'POST')->to(action => 'delete'); # DELETE method?
    $link_action->route('/copy')->name('admin_copy_song_link')->to(action => 'copy');
}


sub list {
    my $c = shift;

    my $song = $c->stash->{song};
    my $table = $c->table('Song::Link::List', song => $song);

    $c->stash(table => $table);
}

sub create {
    my $c = shift;

    my $song = $c->stash->{song};
    my $form = $c->form('Link::Edit', song => $song);
    
    if ($form->process) {
        $c->flash(msg => 'Link added') if $form->action eq 'created';
        $c->redirect_to('admin_list_song_links', song_id => $song->id);
    }
    else {
        $c->stash(form => $form);
    }

}

sub capture {
    my $c = shift;

    my $link_id = $c->stash->{link_id};
    if (my $link = $c->schema->resultset('Link')->find($link_id)) {
        $c->stash(link => $link);
        return 1;
    }
    else {
        $c->reply->not_found;
        return undef;
    }
}

sub edit {
    my $c = shift;

    my $song = $c->stash->{song};
    my $link = $c->stash->{link};
    my $form = $c->form('Link::Edit', song => $song, link => $link);
    
    if ($form->process) {
        $c->flash(msg => 'Link updated') if $form->action eq 'updated';
        $c->redirect_to('admin_list_song_links', song_id => $song->id);
    }
    else {
            $c->stash(form => $form);
    }
}

sub delete {
    my $c = shift;

    my $song = $c->stash->{song};
    my $link = $c->stash->{link};
    my $form = $c->form('Link::Delete', song => $song, link => $link);

    if (my $action = $form->process) {
        $c->flash(msg => $action) if $form->action eq 'deleted';
        $c->redirect_to('admin_list_song_links', song_id => $song->id);
    }
    else {
        $c->stash(form => $form);
    }
}

sub copy {
    my $c = shift;

    my $song = $c->stash->{song};
    my $link = $c->stash->{link};

    my $fields = {
        embed_identifier  => $link->embed_identifier . '-copy',
        embed_class       => $link->embed_class,
        embed_url         => $link->embed_url,
        embed_description => $link->embed_description,
        list_priority     => $link->list_priority,
        list_css          => $link->list_css,
        list_url          => $link->list_url,
        list_description  => $link->list_description,
    };
    my $new_link = $song->add_link($fields);
    $song->render_markdown;

    # We're gonna want to edit the new link, so redirect there
    $c->redirect_to('admin_edit_song_link', song_id => $song->id, link_id => $new_link->id);

}

1;
