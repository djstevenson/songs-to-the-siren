package NeverTire::View::Comment::Render;

use Sub::Exporter -setup => {
    exports => [qw/ render_node /]
};

# TODO Curry this, so we can construct a renderer function
# based on test requirements and on production requirements.
sub render_node {
    my ($visitor, $node, $pre_child, $post_child, $child_sep) = @_;

    # $node = NeverTire::Model::Comment::Node

	my $s = $visitor->($node);
	if ( scalar @{ $node->children } ) {
		$s .= $pre_child;
		$s .= join($child_sep, 
            map {
                render_node($visitor, $_, $pre_child, $post_child, $child_sep)
            }
            @{ $node->children });
		$s .= $post_child;
	}
	return $s;
}

1;
