package SongsToTheSiren::Schema::Role::User::Content;
use utf8;
use Moose::Role;

# TODO Add pod

use DateTime;
use SongsToTheSiren::Markdown;
use Carp qw/ croak /;

use Readonly;

Readonly my $NOT_ADMIN => 'Not admin - permission denied';

# This exists just to keep Result::User down to a more manageable size.
# It extracts the methods relating to content pages etc

sub admin_create_content {
    my ($self, $args) = @_;

    croak $NOT_ADMIN unless $self->admin;

    my $processor = SongsToTheSiren::Markdown->new;
    my $full_args = {%{ $args }, html => $processor->markdown($args->{markdown}), updated_at => DateTime->now,};

    return $self->create_related('content', $full_args);
}

sub admin_edit_content {
    my ($self, $content, $args) = @_;

    croak $NOT_ADMIN unless $self->admin;

    my $processor = SongsToTheSiren::Markdown->new;
    my $full_args = {%{ $args} , html => $processor->markdown($args->{markdown}), updated_at => DateTime->now,};

    # TODO Record who did the update
    $content->update($full_args);

    return $content;
}


no Moose::Role;
1;

