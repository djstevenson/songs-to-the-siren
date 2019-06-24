package NeverTire::Schema::Role::User::Song;
use Moose::Role;

# TODO Add pod

use DateTime;
use Text::Markdown qw/ markdown /;
use Carp qw/ croak /;

use Readonly;

Readonly my $NOT_ADMIN => 'Not admin - permission denied';

# This exists just to keep Result::User down to a more managable size.
# It extracts the methods relating to songs etc

sub admin_create_song {
    my ($self, $args) = @_;

    croak $NOT_ADMIN unless $self->admin;

    my $full_args = {
        %$args,
        full_html    => markdown($args->{full_markdown}),
        summary_html => markdown($args->{summary_markdown}),
        created_at   => DateTime->now,
    };

    return $self->create_related('songs', $full_args);
}

sub admin_edit_song {
    my ($self, $song, $args) = @_;

    croak $NOT_ADMIN unless $self->admin;

    my $full_args = {
        %$args,
        full_html    => markdown($args->{full_markdown}),
        summary_html => markdown($args->{summary_markdown}),
        updated_at   => DateTime->now,
    };

    # TODO Record who did the update
    $song->update($full_args);
    
    return $song;
}

# Admin only
sub approve_comment {
    my ($self, $comment) = @_;

    croak $NOT_ADMIN unless $self->admin;

# TODO Add 'approved_by'
    $comment->update({ approved_at  => DateTime->now });

    return $comment;
}

no Moose::Role;
1;

