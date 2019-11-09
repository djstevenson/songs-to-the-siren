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

has_button create_link => ();
has_button cancel => (style => 'light', skip_validation => 1);

override posted => sub {
	my $self = shift;

    my $create_button = $self->find_button('create_link');
    if ( $create_button->clicked ) {
        # Whitelist what we extract from the submitted form
        my $fields = $self->form_hash(qw/ name url description priority extras /);
        $self->song->add_link($fields);

        $self->action('created');
    }

    return 1;
};

__PACKAGE__->meta->make_immutable;
1;
