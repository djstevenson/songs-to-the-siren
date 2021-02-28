package SongsToTheSiren::Markdown::TimeSignature;
use utf8;
use Moose;
use namespace::autoclean;

with 'SongsToTheSiren::Markdown::Role';

use SongsToTheSiren::View::Link::Render;

# An extension to Text::Markdown - POD docs at end of file

sub process {
    my ($self, $text) = @_;

    $text =~ s{
        \^\$(\d*?)\|(\d*?)\$\^
    }
    {
        $self->_time_signature($1, $2)
    }gex;

    return $text;
}

sub _time_signature {
    my ($self, $upper, $lower) = @_;

    return
        qq{<span class="time-signature"><sup><b><i>${upper}</i></b></sup><sub><b><i>${lower}</i></b></sub></span>};
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

SongsToTheSiren::Markdown::TimeSignature : Processes links for SongsToTheSiren::Markdown

=head1 SYNOPSIS

    my $p = SongsToTheSiren::Markdown::TimeSignature->new(
        song => $song,
    );

    # e.g. Replace ^$5|4$^ with <sup>5</sup><sub>4</sub>
    my $t2 = $p->process($t);

=head1 DESCRIPTION

Does some pre-processing of text to replace ^$m|n$^ with the 
markup to represent a time signature.

Currently, only simple time signatures are supported, 5/4, 4/4, 13/8 etc

Compound times such as 3+2+3/8 could easily be added if required.

=head1 CONSTRUCTOR ARGS

=over

=item song (required, not used)

The base class marks this as required, but we don't use it here.

=back

=head1 METHODS

=over

=item process($text)

Does the replacement.

=back

=head1 AUTHOR

David Stevenson david@ytfc.com

=cut
