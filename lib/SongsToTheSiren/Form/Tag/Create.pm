package SongsToTheSiren::Form::Tag::Create;
use utf8;
use Moose;
use namespace::autoclean;

use SongsToTheSiren::Form::Moose;
extends 'SongsToTheSiren::Form::Base';
with 'SongsToTheSiren::Form::Role';

has '+id' => (default => 'add-tag');

has_field name => (
    type       => 'Input::Text',
    autofocus  => 1,
    filters    => [qw/ TrimEdges /],
    validators => [qw/ Required  /],
    options    => {
        initial_value => q{}
    },
);

has song => (is => 'ro', isa => 'SongsToTheSiren::Schema::Result::Song', required => 1);

has_button create_tag => ();

override posted => sub {
    my $self = shift;

    # Whitelist what we extract from the submitted form
    my $fields = $self->form_hash(qw/ name /);
    return $self->song->add_tag($fields->{name});
};

__PACKAGE__->meta->make_immutable;
1;
