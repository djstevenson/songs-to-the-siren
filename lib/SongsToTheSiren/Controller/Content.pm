package SongsToTheSiren::Controller::Content;
use Mojo::Base 'Mojolicious::Controller';

sub add_routes {
    my ($c, $r) = @_;

    my $u = $r->any('/content')->to(controller => 'content');

    # Capturing the content name
    my $content_action_u = $u->under('/:name')->to(action => 'capture');

    # Non-admin content, with a capture
    $content_action_u->route('/view')->name('view_content')->via('GET')->to(action => 'view');
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

1;
