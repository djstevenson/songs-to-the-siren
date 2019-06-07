package NeverTire::Schema::Role::User::Song;
use Moose::Role;

# TODO Add pod

use DateTime;
use Text::Markdown qw/ markdown /;
use Carp qw/ croak /;


# This exists just to keep Result::User down to a more managable size.
# It extracts the methods relating to songs etc

sub create_song {
    my ($self, $args) = @_;

    croak 'Permission denied' unless $self->admin;

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

    croak 'Permission denied' unless $self->admin;

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

no Moose::Role;
1;

