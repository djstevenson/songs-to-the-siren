package SongsToTheSiren::Markdown::Link;
use Moose;
use namespace::autoclean;

with 'SongsToTheSiren::Markdown::Role';

use SongsToTheSiren::View::Link::Render;

# An extension to Text::Markdown - POD docs at end of file

has _links => (
    is          => 'ro',
    isa         => 'HashRef[SongsToTheSiren::Schema::Result::Link]',
    lazy        => 1,
    default     => sub {
        my $self = shift;

        return {} unless $self->has_song;

        return $self->song->links->links_by_identifier;
    }
);

sub process {
    my ($self, $text) = @_;

    $text =~ s{
        \^\^(.*?)\^\^
    }
    {
        $self->_replacement_link($1)
    }gex;

    return $text;
}

sub _replacement_link {
    my ($self, $identifier) = @_;

    return "**LINK IDENTIFIER NOT FOUND: $identifier**"
        unless exists $self->_links->{$identifier};
    
    my $args = { link => $self->_links->{$identifier} };
    $args->{song} = $self->song if $self->has_song;
    my $renderer = SongsToTheSiren::View::Link::Render->new($args);
    return $renderer->as_html;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 NAME

SongsToTheSiren::Markdown::Link : Processes links for SongsToTheSiren::Markdown

=head1 SYNOPSIS

    my $p = SongsToTheSiren::Markdown::Link->new(
        song => $song
    );

    # Replace ^^identifier^^ with the corresponding link
    my $t2 = $p->process($t);

=head1 DESCRIPTION

Does some pre-processing of text to replace ^^identifier^^ with the 
corresponding link for the specified song.

=head1 CONSTRUCTOR ARGS

=over

=item song (required)

A DBIx::Class result object for the song being rendered. 

We will need this to look up links etc.

=back

=head1 METHODS

=over

=item process($text)

Does the link replacement.

Each sequence ^^identifier^^ is replaced by a link from the database.

Placeholder text is used if the identifier is not found, e.g. when creating
a new song for which we have yet to set up the links.

=back

=head1 AUTHOR

David Stevenson david@ytfc.com

=cut
