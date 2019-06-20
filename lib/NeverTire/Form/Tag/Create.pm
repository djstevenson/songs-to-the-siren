package NeverTire::Form::Tag::Create;
use Moose;
use namespace::autoclean;

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

has '+id'           => (default => 'add-tag');

has_field name => (
    type        => 'Input::Text',
    autofocus   => 1,
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
    options     => {
        initial_value => '',
    },
);

has song => (
    is          => 'ro',
    isa         => 'NeverTire::Schema::Result::Song',
    required    => 1,
);

override posted => sub {
	my $self = shift;

    # Whitelist what we extract from the submitted form
	my $fields = $self->form_hash(qw/ name /);
	return $self->song->add_tag($fields->{name});
};

__PACKAGE__->meta->make_immutable;
1;
