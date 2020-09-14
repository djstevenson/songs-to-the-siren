package SongsToTheSiren::Form::Field::Validator::ValidEmail;
use utf8;
use Moose;
use namespace::autoclean;

extends 'SongsToTheSiren::Form::Field::Validator::Base';
with 'SongsToTheSiren::Form::Field::Validator::Role';


sub validate {
    my ($self, $value) = @_;

    ## no critic (RegularExpressions::RequireExtendedFormatting RegularExpressions::ProhibitComplexRegexes)
    return undef
        if $value
        =~ m{^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$}i;
    ## use critic

    return 'Invalid email address';

}


__PACKAGE__->meta->make_immutable;
1;
