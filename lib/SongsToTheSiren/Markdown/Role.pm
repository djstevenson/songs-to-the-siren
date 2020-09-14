package SongsToTheSiren::Markdown::Role;
use utf8;
use Moose::Role;

# An role to define an interface to markdown pre-processors

has song => (is => 'ro', isa => 'SongsToTheSiren::Schema::Result::Song', predicate => 'has_song');

requires 'process';

no Moose::Role;

1;

__END__

=encoding utf8

=head1 NAME

SongsToTheSiren::Markdown::Role : Interface for Markdown pre-processors

=head1 SYNOPSIS

    package MyPreprocessor;
    use utf8;
    use Moose;
    use namespace::autoclean;

    with 'SongsToTheSiren::Markdown::Role';

    # Role requires us to implement 'process'
    sub process {
        my ($self, $text) = @_;
        ...
        return $transformed_text;
    }

    __PACKAGE__->meta->make_immutable;
    1;

=head1 DESCRIPTION

Holds the 'song' attribute for your preprocessor class, and
requires you to implement the 'process' method.

=head1 AUTHOR

David Stevenson david@ytfc.com
