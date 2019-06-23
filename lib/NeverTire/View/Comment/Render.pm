package NeverTire::View::Comment::Render;
use strict;
use warnings;

use Sub::Exporter -setup => {
    exports => [qw/ render_comments /]
};

sub render_comments {
    my ($app, $root_node, $draw_node) = @_;

    # $root_node = NeverTire::Model::Comment::Node

    $draw_node //= \&_default_renderer;

    return '<ul>' . _render_node($app, $root_node, $draw_node, 0) . '</ul>';
}

sub _render_node {
    my ($app, $node, $draw_node, $level) = @_;

    # $node = NeverTire::Model::Comment::Node

	my $s = '<li>' . $draw_node->($app, $node, $level);
	if ( scalar @{ $node->children } ) {
        $s .= '<ul>';
		$s .= join('', 
            map {
                _render_node($app, $_, $draw_node, $level+1);
            }
            @{ $node->children });
        $s .= '</ul>';
	}
    
    $s .= '</li>';

	return $s;
}

sub _default_renderer {
    my ($app, $node, $level) = @_;

    my $comment = $node->comment;

    my $noun = $level == 0 ? 'Comment' : 'Reply';
    my $s .= '<h4 class="comment-header">';
    $s .= $noun . ' by <span class="author">' . $comment->get_column('author_name')    . '</span>';
    $s .= 'at <span class="date">' .   $app->datetime($comment->created_at)   . '</span>';
    $s .= '</h4>';
    $s .= '<p class="comment-body">' . $comment->comment_html . '</p>';

    return $s;
}

1;
