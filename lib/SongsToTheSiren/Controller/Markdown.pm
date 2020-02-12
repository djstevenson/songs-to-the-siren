package SongsToTheSiren::Controller::Markdown;
use Mojo::Base 'Mojolicious::Controller';

use SongsToTheSiren::Markdown;

sub add_routes {
    my ($c, $r) = @_;

    $r->route('/markdown')->via('POST')->to('markdown#render_markdown');
}

sub render_markdown {
    my $c = shift;

    # TODO This repeats in several controllers, can we "DRY" it?
    # TODO e.g. an 'under' stage in the route?
    # TODO Check - I think this is already done!!
    return $c->render(status => 403, text => 'Nah')
        unless exists $c->stash->{auth_user};

    my $processor = SongsToTheSiren::Markdown->new;
    my $markdown = $c->param('markdown');
    my $html = $processor->markdown($markdown);
    $c->render(text => $html);
}


1;