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

# TODO This'd be better in a template, given that
#      it's basically HTML with minor logic and
#      the comment count will be low.
sub _default_renderer {
    my ($app, $node, $level) = @_;

    my $comment = $node->comment;

    my $noun = $level == 0 ? 'Comment' : 'Reply';

    my $author    = $comment->get_column('author_name');
    my $timestamp = $app->datetime($comment->created_at);
    my $html      = $comment->comment_html;

    my $approved   = $comment->approved_at;
    my $mod_status = $approved ? 'moderated' : 'unmoderated';
    my $s .= qq{<h4 class="comment-header ${mod_status}">};
    $s .= qq{<span class="author">${noun} by <strong>${author}</strong></span>};
    $s .= qq{<span class="date">at ${timestamp}</span>};
    $s .= qq{</h4><p class="comment-body">${html}</p>};
    if ( my $auth_user = $app->stash->{auth_user} ) {
        if ( $approved ) {
            $s .= '<p><a href="">Reply to this comment</a></p>';
        } elsif ( $auth_user->admin ) {
            $s .= '<p><a href="">Approve</a> --- <a href="">Reject</a></p>';
        }
    }

    return $s;
}

1;
