package SongsToTheSiren::View::Link::Default;
use Moose::Role;

with 'SongsToTheSiren::View::Link::Role';

# TODO POD docs

# Provides a basic renderer for embedded links that generates:
# <a href="${url}" target="blank">${description}</a>
# where ${xxx} is the value of a field in the link record.

sub render {
    my $self = shift;

    my $link = $self->link;

    return sprintf(
        '<a href="%s" target="_blank">%s</a>',
        $link->embed_url,
        $link->embed_description,
    );
}

1;
