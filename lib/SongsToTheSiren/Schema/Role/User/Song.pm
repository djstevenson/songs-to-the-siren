package SongsToTheSiren::Schema::Role::User::Song;
use Moose::Role;

# TODO Add pod

use DateTime;
use Carp qw/ croak /;

use Readonly;

Readonly my $NOT_ADMIN => 'Not admin - permission denied';

# This exists just to keep Result::User down to a more manageable size.
# It extracts the methods relating to songs etc

sub admin_create_song {
    my ($self, $args) = @_;

    croak $NOT_ADMIN unless $self->admin;

    my $now = DateTime->now;

    my $full_args = {
        %$args,
        full_html    => '',
        summary_html => '',
        created_at   => $now,
        updated_at   => $now,
    };

    my $song = $self->create_related('songs', $full_args);
    $song->render_markdown;

    return $song;
}

sub admin_edit_song {
    my ($self, $song, $args) = @_;

    croak $NOT_ADMIN unless $self->admin;

    my $full_args = {
        %$args,
        updated_at => DateTime->now,
    };

    # TODO Record who did the update
    $song->update($full_args);
    $song->render_markdown;

    return $song;
}

sub approve_comment {
    my ($self, $comment) = @_;

    croak $NOT_ADMIN unless $self->admin;

    # TODO Add 'approved_by'
    $comment->update({ approved_at  => DateTime->now });

    return $comment;
}

sub reject_comment {
    my ($self, $comment) = @_;

    croak $NOT_ADMIN unless $self->admin;

    # TODO Maybe save rejected comments somewhere.
    $comment->delete;
}

no Moose::Role;
1;

