package SongsToTheSiren::Markdown::Shortcut;
use Moose;
use namespace::autoclean;

with 'SongsToTheSiren::Markdown::Role';

use SongsToTheSiren::View::Link::Render;

# An extension to Text::Markdown - POD docs at end of file

sub process {
    my ($self, $text) = @_;

    $text =~ s{
        \^~(.*?)~\^
    }
    {
        $self->_expand($1)
    }gex;

    return $text;
}

# TODO Put this in the database or (better) a config file
has _expansions => (
    is          => 'ro',
    isa         => 'HashRef[Str]',
    lazy        => 1,
    default     => sub {
        return {
            shrug => '&macr;&bsol;&lowbar;&lpar;&#x30C4;&rpar;&lowbar;&sol;&macr;',
        };
    },
);

sub _expand {
    my ($self, $word) = @_;

    my $ex = $self->_expansions;
    return $ex->{$word} if exists $ex->{$word};

    return qq{^~NOT MATCHED: ${word}~^};
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 NAME

SongsToTheSiren::Markdown::Shortcut : Processes shortcuts for SongsToTheSiren::Markdown

=head1 SYNOPSIS

    my $p = SongsToTheSiren::Markdown::Shortcut->new(
        song => $song,
    );

    # Replace ^~word~^ with lookup of the replacement for 'word'.
    # e.g. replaces ^~shrug~^ with
    # '&macr;&bsol;&lowbar;&lpar;&#x30C4;&rpar;&lowbar;&sol;&macr;'

    my $t2 = $p->process($t);

=head1 DESCRIPTION

Does some pre-processing of text to replace ^~word~^ with a
pre-defined expansion.


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
