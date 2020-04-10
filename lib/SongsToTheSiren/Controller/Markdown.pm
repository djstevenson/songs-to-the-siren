package SongsToTheSiren::Controller::Markdown;
use Mojo::Base 'Mojolicious::Controller';

use SongsToTheSiren::Markdown;

sub add_routes {
    my ($c, $r) = @_;

    $r->route('/markdown')->via('POST')->to('markdown#render_markdown');
}

sub render_markdown {
    my $c = shift;

    # TODO Check this is already done via the router, and delete it if so
    return $c->render(status => 403, text => 'Nah')
        unless exists $c->stash->{auth_user};

    # If we are editing a song, pass it into the markdown
    # constructor, so we can resolve link codes. If creating
    # a new song, we'll have to pass nothing and the links
    # will get dummied out.
    my %args = ();
    if ( my $song_id = $c->param('song') ) {
        my $rs = $c->schema->resultset('Song');
        my $song = $rs->find($song_id);
        if ($song) {
            $args{song} = $song;
        }
    }

    my $processor = SongsToTheSiren::Markdown->new(%args);
    my $markdown = $c->param('markdown');
    my $html = $processor->markdown($markdown);
    $c->render(text => $html);
}


1;
