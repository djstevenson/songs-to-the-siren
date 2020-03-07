package SongsToTheSiren::View::Link::Default;
use Moose::Role;

with 'SongsToTheSiren::View::Link::Role';

# TODO POD docs

# Provides a basic renderer for links that generates:
# <a href="${url}" target="blank">${description}</a>
# where ${xxx} is the value of a field in the link record.

sub render {
    my $self = shift;

    my $link = $self->link;

    return sprintf(
        '<a href="%s" target="_blank"%s>%s</a>',
        $link->url,
        ($link->title ? q{ title="} . $link->title . q{"} : ''),
        $link->description,
    );
}

1;
