package SongsToTheSiren::View::Link::YouTubeEmbedded;
use Moose::Role;

with 'SongsToTheSiren::View::Link::Role';

# TODO POD docs

# Provides a basic renderer for links that generates:
# <a href="${url}">${description}</a>
# where ${xxx} is the value of a field in the link record.

sub render {
    my $self = shift;

    my $link = $self->link;

    return sprintf(
        '<iframe style="float:right" width="560" height="315" src="%s" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>',
        $link->url
    );
}

1;
