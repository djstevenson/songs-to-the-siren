package NeverTire::Form::Link::Edit;
use Moose;
use namespace::autoclean;

# TODO Loadsa dupe code with Link::Create form, can we put most of this in a base class or something?

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

has '+id' => (default => 'edit-link');

has_field name => (
    type        => 'Input::Text',
    autofocus   => 1,
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
);

# TODO Add URL validation
has_field url => (
    type        => 'Input::Text',
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
);

has_field priority => (
    type        => 'Input::Text',
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  ValidInteger /],
);

has_field description => (
    type        => 'Input::Text',
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
);

has_field extras => (
    type        => 'Input::Text',
    filters     => [qw/ TrimEdges /],
);

has song => (
    is          => 'ro',
    isa         => 'NeverTire::Schema::Result::Song',
    required    => 1,
);

has link => (
    is          => 'ro',
    isa         => 'NeverTire::Schema::Result::Link',
    required    => 1,
);

has_button update_link => ();
has_button cancel => (style => 'light', skip_validation => 1);

override posted => sub {
	my $self = shift;

    # Whitelist what we extract from the submitted form
	my $fields = $self->form_hash(qw/ name url description priority extras /);
	return $self->link->update($fields);
};

# Prepopulate GET form from the song object
sub BUILD {
    my $self = shift;

 	$self->data_object($self->link);
}

__PACKAGE__->meta->make_immutable;
1;
