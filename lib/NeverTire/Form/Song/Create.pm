package NeverTire::Form::Song::Create;
use Moose;
use namespace::autoclean;

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

has '+submit_label' => (default => 'New song');
has '+id'           => (default => 'new-song');

has_field title => (
    type        => 'Input::Text',
    autofocus   => 1,
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
);

has_field album => (
    type        => 'Input::Text',
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
);

has_field artist => (
    type        => 'Input::Text',
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
);

has_field date_released => (
    label       => 'Date Released',
    type        => 'Input::Text',
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
);


has_field summary_markdown => (
    label       => 'Summary',
    type        => 'Input::TextArea',
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
);

has_field summary_preview => (
    type        => 'Html',
    options     => {
        html => q{<div class="markdown summary">Summary preview here</div>},
    },
);

has_field full_markdown => (
    label       => 'Full Description',
    type        => 'Input::TextArea',
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
);

has_field full_preview => (
    type        => 'Html',
    options     => {
        html => q{<div class="markdown full">Full preview here</div>},
    },
);


override posted => sub {
	my $self = shift;

	my $user = $self->c->stash->{auth_user};

    # Whitelist what we extract from the submitted form
	my $fields = $self->form_hash(qw/ title album artist date_released summary_markdown full_markdown /);
	return $user->create_song($fields);
};

__PACKAGE__->meta->make_immutable;
1;
