package NeverTire::Schema::Role::User::Comment;
use Moose::Role;

# TODO Add pod

use DateTime;
use Text::Markdown qw/ markdown /;
use Carp qw/ croak /;

# This exists just to keep Result::User down to a more managable size.
# It extracts the methods relating to songs etc

sub new_song_comment {
    my ($self, $song, $data) = @_;

    return $self->_new_comment($song->id, undef, $data);
}

sub new_song_reply {
    my ($self, $parent_comment, $data) = @_;

    return $self->_new_comment($parent_comment->song_id, $parent_comment->id, $data);
}

sub _new_comment {
    my ($self, $song_id, $parent_id, $data) = @_;

    my $full_args = {
        %$data,
        parent_id    => $parent_id,
        song_id      => $song_id,
        comment_html => markdown($data->{comment_markdown}),
        created_at   => DateTime->now,
    };

    return $self->create_related('comments', $full_args);
}

no Moose::Role;
1;

