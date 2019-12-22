package NeverTire::Model::Comment::Forest;
use strict;
use warnings;

# TODO POD

use NeverTire::Model::Comment::Node;

use Sub::Exporter -setup => {
    exports => [qw/ make_forest /]
};

# Called as a class method
# $song is a NeverTire::Schema::ResultSet::Comment
#
# Unmoderated comments excluded except:
#   * Admin user sees all comments, modded or not
#   * Non-admin user sees all moderated comments and
#     their OWN unmodded comments. 

sub make_forest {
    my ($song, $user) = @_;

    # Get them in ascending order so we process the
    # oldest first. But we add nodes to the root list,
    # or to their parent's children list, in reverse
    # order (unshift rather than push).
    # This gives us the right order for display.
    my $comment_rs = $song
        ->comments
        ->for_display
        ->for_user($user)
        ->id_order;

    my $root_nodes = [];
    my $all_nodes  = {};
    
    while (my $comment = $comment_rs->next) {
        my $node = NeverTire::Model::Comment::Node->new(
            comment => $comment
        );

        # Reply to existing comment?
        if (defined (my $parent_id = $comment->parent_id) )  {
            # Fail if the parent isn't found, we have inconsistent
            # data. The DB schema ensures his shouldn't happen.
            die 'Invalid comment tree for song: ' . $song->id
                unless exists $all_nodes->{$parent_id};

            $all_nodes->{$parent_id}->add_child($node);
        }
        else {
            # New top-level comment.
            unshift @{ $root_nodes }, $node;
        }
        $all_nodes->{ $comment->id } = $node;
    }

    return $root_nodes;
}

1;
