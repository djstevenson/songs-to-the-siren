package NeverTire::Controller::Markdown;
use Mojo::Base 'Mojolicious::Controller';

use Text::Markdown qw/ markdown /;

sub add_routes {
    my ($c, $r) = @_;

    $r->route('/markdown')->via('POST')->to('markdown#render');
}

sub render {
    my $c = shift;

    $c->assert_user;
    
    my $markdown = $c->param('markdown');
    my $html = markdown($markdown);
    $c->render(text => $html);
}


1;
