package NeverTire::Schema::Role::User::Comment;
use Moose::Role;

# TODO Add pod

use DateTime;

# Use standard markdown rather than our extensions, as 
# this is used by non-admins.
use Text::Markdown qw/ markdown /;

# This exists just to keep Result::User down to a more manageable size.
# It extracts the methods relating to comments etc

sub new_song_comment {
    my ($self, $song, $parent, $data) = @_;

    my $parent_id;
    if ($parent) {
        die 'Cannot reply to unapproved article' unless $parent->approved_at;
        $parent_id = $parent->id;
    }

    my $full_args = {
        %$data,
        parent_id    => $parent_id,
        song_id      => $song->id,
        comment_html => markdown($data->{comment_markdown}),
        created_at   => DateTime->now,
    };

    return $self->create_related('comments', $full_args);
}

sub edit_song_comment {
    my ($self, $comment, $data) = @_;

    # The text here is surely part of the view?
    # TODO Record the date/reason for the edit in the
    # DB and render that properly in the view.
    my $markdown = $data->{comment_markdown}
     . qq{\n\nEdited by admin};

    my $full_args = {
        %$data,
        comment_html => markdown($markdown),
    };

    return $comment->update($full_args);
}

no Moose::Role;
1;

