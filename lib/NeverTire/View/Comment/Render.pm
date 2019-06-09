package NeverTire::View::Comment::Render;

use Sub::Exporter -setup => {
    exports => [qw/ render_comments /]
};

sub render_comments {
    my ($app, $root_node, $draw_node) = @_;

    # $root_node = NeverTire::Model::Comment::Node

    $draw_node //= \&_default_renderer;

    return '<ul>' . _render_node($app, $root_node, $draw_node) . '</ul>';
}

sub _render_node {
    my ($app, $node, $draw_node) = @_;

    # $node = NeverTire::Model::Comment::Node

	my $s = '<li>' . $draw_node->($app, $node);
	if ( scalar @{ $node->children } ) {
        $s .= '<ul>';
		$s .= join('', 
            map {
                _render_node($app, $_, $draw_node);
            }
            @{ $node->children });
        $s .= '</ul>';
	}
    
    $s .= '</li>';

	return $s;
}

sub _default_renderer {
    my ($app, $node) = @_;

    my $comment = $node->comment;

    my $s = '<div class="comment">';

    $s .= '<span class="author">By ' . $comment->author_id    . '</span>';
    $s .= '<span class="date">At ' .   $app->datetime($comment->created_at)   . '</span>';
    $s .= '<p class="comment-body">' . $comment->comment_html . '</p>';
    
    $s .= '</div>';

    return $s;
}

1;
