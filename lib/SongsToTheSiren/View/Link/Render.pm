package SongsToTheSiren::View::Link::Render;
use Moose;
use namespace::autoclean;

use Moose::Util qw/ apply_all_roles /;

# TODO POD docs

# A renderer for links. Pass in:
# link (required)
# song (if you have one, otherwise we'll lazily get if from the link if req)

# This method will attach the role defined by the 'class' field of
# the link record, then call the render() method that the role
# provides.

# Usage:
#  my $renderer = SongsToTheSiren::View::Link::Render->new(
#     link => $link,
#     song => $song, # if you already have one loaded from DB
#  );
#  my $link_html = $renderer->as_html;

# Link object is required.
has link => (
    is          => 'ro',
    isa         => 'SongsToTheSiren::Schema::Result::Link',
    required    => 1,
);

# Supply a song object in the constructor if you already
# have one, otherwise it wil be lazily fetched from the
# link object if required, which will likely mean an extra
# DB query.
has song => (
    is          => 'ro',
    isa         => 'SongsToTheSiren::Schema::Result::Song',
    lazy        => 1,
    default     => sub { return shift->link->song; },
);

sub as_html {
    my $self = shift;

    # On a high-volume site, we might cache renderer objects,
    # but after the first one loads the role, it only takes 
    # about 0.16ms to build new objects in the future, so that's
    # fine for this site.
    my $link = $self->link;
    my $role_name = 'SongsToTheSiren::View::Link::' . $link->class;
    apply_all_roles($self, $role_name);

    return $self->render;
}


__PACKAGE__->meta->make_immutable;
1;
