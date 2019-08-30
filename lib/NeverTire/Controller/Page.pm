package NeverTire::Controller::Page;
use Mojo::Base 'Mojolicious::Controller';

sub add_routes {
    my ($c, $r) = @_;

    my $u = $r->any('/page')->to(controller => 'page');

    # Routes that capture a page name
    my $page_action_u = $u->under('/:name')->to(action => 'capture');

    $page_action_u->route('/view')->name('view_page')->via('GET')->to(action => 'view');


    # Admin routes, no capture:
    my $a = $u->require_admin;
    $a->route('/list')->name('list_pages')->via('GET')->to(action => 'list');
    # $a->route('/create')->name('create_song')->via('GET', 'POST')->to(action => 'create');
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
    if ( my $page = $rs->search({ name => $name} )->single ) {
        $c->stash( page => $page );
    }
    else {
        $c->reply->not_found;
        return undef;
    }

    return 1;
}


sub view {}

1;
