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

    my $full_args = {
        %$data,
        song_id      => $song->id,
        comment_html => markdown($data->{comment_markdown}),
        created_at   => DateTime->now,
    };

    return $self->create_related('comments', $full_args);
}

no Moose::Role;
1;

