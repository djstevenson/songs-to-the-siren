package SongsToTheSiren::View::Link::Default;
use Moose::Role;

with 'SongsToTheSiren::View::Link::Role';

# POD docs at bottom of file

# Provides a basic renderer for embedded links that generates:
# <a href="${url}" target="blank">${description}</a>
# where ${xxx} is the value of a field in the link record.

sub render {
    my $self = shift;

    my $link = $self->link;

    return sprintf('<a href="%s" target="_blank">%s</a>', $link->embed_url, $link->embed_description,);
}

1;

__END__

=pod

=head1 NAME

SongsToTheSiren::View::Link::Default : Default renderer for links

=head1 SYNOPSIS

    use Moose::Util qw/ apply_all_roles /;

    apply_all_roles($obj, 'SongsToTheSiren::View::Link::Default');

=head1 DESCRIPTION

Provides a role to render links in song articles.

This method renders a simple-ish <a href="">xxx</a> type HTML link
for the given URL

=head1 METHODS

=over

=item render

Renders the link for $self->link, which is a
SongsToTheSiren::Schema::Result::Link object.

=back

=head1 AUTHOR

David Stevenson david@ytfc.com

=cut
