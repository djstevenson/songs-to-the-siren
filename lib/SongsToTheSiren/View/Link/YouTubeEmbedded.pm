package SongsToTheSiren::View::Link::YouTubeEmbedded;
use Moose::Role;

with 'SongsToTheSiren::View::Link::Role';

# TODO POD docs

# Provides a renderer for an IFRAME to embed a float-right
# embedded YouTube video.

sub render {
    my $self = shift;

    my $url = $self->link->url;

    return qq{<div class="embed-container"><iframe src="${url}" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>};
}

1;
