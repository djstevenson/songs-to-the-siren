package SongsToTheSiren::View::Link::YouTubeEmbedded;
use Moose::Role;

with 'SongsToTheSiren::View::Link::Role';

# POD docs at bottom of file

# Provides a renderer for an IFRAME to embed a float-right
# embedded YouTube video.

sub render {
    my $self = shift;

    my $url = $self->link->embed_url;

    return
        qq{<div class="embed-container"><iframe src="${url}" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>};
}

1;

__END__

=encoding utf8

=head1 NAME

SongsToTheSiren::View::Link::YouTubeEmbedded : Render embedded YouTube links

=head1 SYNOPSIS

    use Moose::Util qw/ apply_all_roles /;

    apply_all_roles($obj, 'SongsToTheSiren::View::Link::YouTubeEmbedded');

=head1 DESCRIPTION

Provides a role to render links for Embedded YouTube videos. 

It renders the YT-specified IFRAME around the given url.

=head1 METHODS

=over

=item render

Renders the link for $self->link, which is a
SongsToTheSiren::Schema::Result::Link object.

=back

=head1 AUTHOR

David Stevenson david@ytfc.com

=cut
