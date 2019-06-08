package NeverTire::Model::Comment::Forest;
use Moose;
use namespace::autoclean;

# TODO POD

use NeverTire::Model::Comment::Node;

# $song is a NeverTire::Schema::ResultSet::Comment
sub make_forest {
    my ($self, $song) = @_;

    # Get them in ascending order.
    # Because we 'push' onto the node
    # list, we end up with newest at the
    # top, which is what we want.
    my $comment_rs => $song
        ->comments
        ->where_approved
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
            push @{ $root_nodes }, $node;
        }
        $all_nodes->{ $comment->id } = $node;
    }

}


__PACKAGE__->meta->make_immutable;
1;
