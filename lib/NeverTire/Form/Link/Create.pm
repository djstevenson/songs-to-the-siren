package NeverTire::Form::Link::Create;
use Moose;
use namespace::autoclean;

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

has '+id' => (default => 'add-link');

has_field name => (
    type        => 'Input::Text',
    autofocus   => 1,
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
    options     => {
        initial_value => '',
    },
);

# TODO Add URL validation
has_field url => (
    type        => 'Input::Text',
    autofocus   => 1,
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
    options     => {
        initial_value => '',
    },
);

# TODO Add integer validation
has_field priority => (
    type        => 'Input::Text',
    autofocus   => 1,
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
    options     => {
        initial_value => '',
    },
);

# TODO Add integer validation
has_field extras => (
    type        => 'Input::Text',
    autofocus   => 1,
    filters     => [qw/ TrimEdges /],
    options     => {
        initial_value => '',
    },
);

has song => (
    is          => 'ro',
    isa         => 'NeverTire::Schema::Result::Song',
    required    => 1,
);

has_button create_link => ();

override posted => sub {
	my $self = shift;

    # Whitelist what we extract from the submitted form
	my $fields = $self->form_hash(qw/ name url priority extras /);
	return $self->song->add_link($fields);
};

__PACKAGE__->meta->make_immutable;
1;
