package NeverTire::Markdown;
use Moose;
use namespace::autoclean;
use Text::Markdown;

use NeverTire::Markdown::Link;

# An extension to Text::Markdown - POD docs at end of file

has song => (
    is          => 'ro',
    isa         => 'NeverTire::Schema::Result::Song',
    required    => 1,
);

has _preprocessors => (
    is          => 'ro',
    isa         => 'ArrayRef[NeverTire::Markdown::Role]',
    lazy        => 1,
    default     => sub {
        my $self = shift;

        my $song = $self->song;

        my @classes = (
            'NeverTire::Markdown::Link',
        );
        return [
            map { $_->new( song => $song ) } @classes
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

NeverTire::Markdown : Extensions for Text::Markdown

=head1 SYNOPSIS

    my $markdown_processor = NeverTire::Markdown->new(
        song => $song
    );

    my $html = $markdown_processor->markdown($txt);

=head1 DESCRIPTION

Does some pre-processing of text before passing it to the markdown
method of Text::Markdown

=head1 CONSTRUCTOR ARGS

=over

=item song (required)

A DBIx::Class result object for the song being rendered. 

We'll need this to look up links etc.

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

=back

=head1 AUTHOR

David Stevenson david@ytfc.com
