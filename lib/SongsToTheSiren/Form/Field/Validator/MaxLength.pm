package SongsToTheSiren::Form::Field::Validator::MaxLength;
use utf8;
use Moose;
use namespace::autoclean;

extends 'SongsToTheSiren::Form::Field::Validator::Base';
with 'SongsToTheSiren::Form::Field::Validator::Role';

has max => (is => 'ro', isa => 'Int', required => 1);

sub validate {
    my ($self, $value) = @_;

    my $max = $self->max;

    return "Maximum length $max" if length($value // q{}) > $max;
    return undef;
}


__PACKAGE__->meta->make_immutable;
1;
