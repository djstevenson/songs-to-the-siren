package NeverTire::View::Comment::Render;

use Sub::Exporter -setup => {
    exports => [qw/ render_comments /]
};

sub render_comments {
    my ($root_node, $draw_node) = @_;

    # $root_node = NeverTire::Model::Comment::Node

    return '<ul>' . _render_node($root_node, $draw_node) . '</ul>';
}

sub _render_node {
    my ($node, $draw_node) = @_;

    # $node = NeverTire::Model::Comment::Node

	my $s = '<li>' . $draw_node->($node);
	if ( scalar @{ $node->children } ) {
        $s .= '<ul>';
		$s .= join('', 
            map {
                _render_node($_, $draw_node);
            }
            @{ $node->children });
        $s .= '</ul>';
	}
    
    $s .= '</li>';

	return $s;
}

1;
