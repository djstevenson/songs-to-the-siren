package NeverTire::Controller::Text;
use Mojo::Base 'Mojolicious::Controller';

# $r  = routes
# $rl = routes for which you need to be logged-in

use Text::Markdown qw/ markdown /;

sub add_routes {
    my ($c, $r, $rl) = @_;

    my $ul = $rl->any('/text')->to(controller => 'text');

    # These are admin functions, need to be logged in for all of them.
    $ul->route('/render')->name('render_markdown')->via('GET', 'POST')->to(action => 'render_markdown');
}

sub render_markdown {
    my $c = shift;

    my $markdown = $c->param('markdown');
    print STDERR "M=", $markdown, "\n\n";
    my $html = markdown($markdown);
    print STDERR "H=", $html, "\n\n";
    $c->render(text => $html);
}


1;
