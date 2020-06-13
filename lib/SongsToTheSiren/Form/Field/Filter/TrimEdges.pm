package SongsToTheSiren::Form::Field::Filter::TrimEdges;
use namespace::autoclean;
use Moose;

extends 'SongsToTheSiren::Form::Field::Filter::Base';
with 'SongsToTheSiren::Form::Field::Filter::Role';


sub filter {
    my ($self, $value) = @_;

    $value =~ s/^\s+//;
    $value =~ s/\s+$//;
    return $value;
}


__PACKAGE__->meta->make_immutable;
1;
