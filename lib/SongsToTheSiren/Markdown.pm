package SongsToTheSiren::Markdown;
use Moose;
use namespace::autoclean;
use Text::Markdown;

use SongsToTheSiren::Markdown::Link;
use SongsToTheSiren::Markdown::TimeSignature;

# An extension to Text::Markdown - POD docs at end of file

has song => (
    is          => 'ro',
    isa         => 'SongsToTheSiren::Schema::Result::Song',
    predicate   => 'has_song',
);

has _preprocessors => (
    is          => 'ro',
    isa         => 'ArrayRef[SongsToTheSiren::Markdown::Role]',
    lazy        => 1,
    default     => sub {
        my $self = shift;

        my $args = $self->has_song ? {song => $self->song} : {};

        my @classes = ( qw/ Link TimeSignature / );

        return [
            map { "SongsToTheSiren::Markdown::$_"->new( $args ) } @classes
        ];
    }
);

sub markdown {
    my ($self, $text) = @_;

    foreach my $processor (@{ $self->_preprocessors }) {
        $text = $processor->process($text);
    }

    return Text::Markdown::markdown($text);
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 NAME

SongsToTheSiren::Markdown : Extensions for Text::Markdown

=head1 SYNOPSIS

    my $markdown_processor = SongsToTheSiren::Markdown->new(
        song => $song
    );

    my $html = $markdown_processor->markdown($txt);

=head1 DESCRIPTION

Does some pre-processing of text before passing it to the markdown
method of Text::Markdown

=head1 CONSTRUCTOR ARGS

=over

=item song (preferred)

A DBIx::Class result object for the song being rendered. 

We'll need this to look up links etc. 

If you don't have a song object yet, leave this out, but all
link lookups will fail and return placeholder text.

=back

=head1 METHODS

=over

=item markdown($text)

Preprocesses the text before returning the result of
passing it to Text::Markdown::markdown

=back

=head1 PREPROCESSING

=over

=item Links

The sequence ^^identifier^^ is replaced by a link from the database.

Placeholder text is used if the identifier is not found, e.g. when creating
a new song where we haven't set up the links yet.

=item Time Signatures

The sequence ^$n/m$^ is replaced by markup representing a time signature,
e.g. ^$5/4$^ for Juliana Hatfield's Spin the Bottle.

=back

=head1 AUTHOR

David Stevenson david@ytfc.com
