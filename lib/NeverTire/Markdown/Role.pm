package NeverTire::Markdown::Role;
use Moose::Role;

# An role to define an interface to markdown pre-processors

has song => (
    is          => 'ro',
    isa         => 'NeverTire::Schema::Result::Song',
    predicate   => 'has_song',
);

requires 'process';

no Moose::Role;

1;

__END__

=pod

=head1 NAME

NeverTire::Markdown::Role : Interface for Markdown pre-processors

=head1 SYNOPSIS

    package MyPreprocessor;
    use Moose;
    use namespace::autoclean;

    with 'NeverTire::Markdown::Role';

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
