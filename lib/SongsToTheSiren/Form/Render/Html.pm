package SongsToTheSiren::Form::Render::Html;
use Moose::Role;
use namespace::autoclean;

sub render{
    my $self = shift;

    return $self->options->{html};
}

1;
