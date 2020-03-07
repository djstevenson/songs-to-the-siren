package SongsToTheSiren::View::Link::YouTubeEmbedded;
use Moose::Role;

with 'SongsToTheSiren::View::Link::Role';

# TODO POD docs

# Provides a renderer for an IFRAME to embed a float-right
# embedded YouTube video.

sub render {
    my $self = shift;

    my $link = $self->link;

    return sprintf(
        '<iframe style="float:right" width="560" height="315" src="%s" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>',
        $link->url
    );
}

1;
