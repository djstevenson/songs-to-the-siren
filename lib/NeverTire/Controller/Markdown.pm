package NeverTire::Controller::Markdown;
use Mojo::Base 'Mojolicious::Controller';

use Text::Markdown qw/ markdown /;

sub add_routes {
    my ($c, $r) = @_;

    $r->route('/markdown')->via('POST')->to('markdown#render_markdown');
}

sub render_markdown {
    my $c = shift;

    $c->assert_user;
     
    my $markdown = $c->param('markdown');
    my $html = markdown($markdown);
    $c->render(text => $html);
}


1;
