package NeverTire::View::Comment::Render;
use strict;
use warnings;

use Mojo::Util qw/ xml_escape /;

use Sub::Exporter -setup => {
    exports => [qw/ render_comments /]
};

sub render_comments {
    my ($app, $root_node, $draw_node) = @_;

    # $root_node = NeverTire::Model::Comment::Node

    $draw_node //= \&_default_renderer;

    return '<ul class="comment-root">' . _render_node($app, $root_node, $draw_node, 0) . '</ul>';
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

    my ($noun, $parent) = $level == 0
        ? ('Comment', undef)
        : ('Reply', $comment->parent);

    my $author     = $comment->get_column('author_name');
    my $timestamp  = $app->datetime($comment->created_at);
    my $html       = $comment->comment_html;
    my $at         = '';

    # TODO structure this better, this method is too long.
    # TODO This is way too hard to read.
    # e.g. add private methods to build format headers, body, etc separately
    # then bring them together here.
    #      Or do it in templates rather than Perl.

    # TODO Are we even HTML entity-encoding everything we need to?

    my $approved   = $comment->approved_at;
    my $mod_status = $approved ? 'moderated' : 'unmoderated';
    my $id = $comment->id;
    my $s = sprintf('<a name="comment-%d"></a>', $id);
    $s .= qq{<div class="${mod_status}">};
    $s .=  q{<h4 class="comment-header">};
    $s .= qq{<span class="author">${noun} #${id} by <strong>${author}</strong> </span>};
    $s .= qq{<span class="date">${timestamp}</span>};
    if ( $parent ) {
        my $parent_id   = $parent->id;
        my $parent_name = $parent->author->name;
        $s .= sprintf(' (reply to <a href="#comment-%d">#%d</a>)', $parent_id, $parent_id );
        $at = qq{<span class="comment-at">\@${parent_name}</span> };
    }
    my $mod = $approved ? '' : '<span class="mod-warning">COMMENT AWAITING APPROVAL: </span>';
    my $edits = _render_edits($app, $comment);
    $s .= qq{</h4><div class="comment-body">${mod}${at}${html}${edits}</div>};

    if ( my $auth_user = $app->stash->{auth_user} ) {
        if ( $approved ) {
            my $url = $app->url_for('new_song_reply', song_id => $comment->song->id, comment_id => $comment->id);
            $s .= qq{<p><a href="${url}">Reply to this comment</a></p>};
        } elsif ( $auth_user->admin ) {
            my $approve_url = $app->url_for('admin_approve_comment', song_id => $comment->song->id, comment_id => $comment->id);
            my $reject_url  = $app->url_for('admin_reject_comment',  song_id => $comment->song->id, comment_id => $comment->id);
            my $edit_url    = $app->url_for('admin_edit_comment',    song_id => $comment->song->id, comment_id => $comment->id);
            $s .= qq{<p><a href="${approve_url}">Approve</a> --- <a href="${reject_url}">Reject</a> --- <a href="${edit_url}">Edit</a></p>};
        }
    }

    $s .= q{</div>};  # Closes the div modstatus

    return $s;
}

sub _render_edits {
    my ($app, $comment) = @_;

    my $s = '';

    my @edits = $comment->edits->search(undef, {
        order_by => {-asc => 'edited_at'}
    })->all;

    if ( scalar @edits ) {
        $s .= q{<div class="comment-edits"><h4>Edits</h4><ul>};
        foreach my $edit ( @edits ) {
            $s .= sprintf(q{<li>Edited by %s %s - %s</li>},
                xml_escape($edit->editor->name),
                xml_escape($app->datetime($edit->edited_at)),
                xml_escape($edit->reason),
            );
        }
        $s .= q{</ul></div>};
    }

    return $s;
}

1;
