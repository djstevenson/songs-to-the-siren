package NeverTire::View::Link::YouTubeEmbedded;
use Moose::Role;

with 'NeverTire::View::Link::Role';

# TODO POD docs

# Provides a basic renderer for links that generates:
# <a href="${url}">${description}</a>
# where ${xxx} is the value of a field in the link record.

sub render {
    my $self = shift;

    my $link = $self->link;

    return sprintf(
        '<a href="%s" class="youtube-embedded">%s</a>',
        $link->url,
        $link->description,
    );
}

1;
