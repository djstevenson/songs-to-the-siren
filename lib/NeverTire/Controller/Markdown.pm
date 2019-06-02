package NeverTire::Controller::Markdown;
use Mojo::Base 'Mojolicious::Controller';

use Text::Markdown qw/ markdown /;

sub add_routes {
    my ($c, $routes) = @_;

    my $ul = $routes->{admin} ->any('/markdown')->to(controller => 'markdown');

    # These are admin functions, need to be logged in for all of them.
    $ul->route('/render')->name('render_markdown')->via('POST')->to(action => 'render_markdown');
}

sub render_markdown {
    my $c = shift;

    my $markdown = $c->param('markdown');
    my $html = markdown($markdown);
    $c->render(text => $html);
}


1;
