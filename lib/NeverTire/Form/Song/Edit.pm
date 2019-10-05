package NeverTire::Form::Song::Edit;
use Moose;
use namespace::autoclean;


# TODO Loadsa dupe code with Song::Create form, can we put most of this in a base class or something?

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

has '+id' => (default => 'edit-song');

has song => (
    is          => 'ro',
    isa         => 'NeverTire::Schema::Result::Song',
    required    => 1,
);

has_field title => (
    type        => 'Input::Text',
    autofocus   => 1,
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
);

has_field artist => (
    type        => 'Input::Text',
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
);

has_field album => (
    type        => 'Input::Text',
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
);

has_field image => (
    type        => 'Input::Text',
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
);

# TODO Proper select menu for countries
has_field country => (
    type        => 'Input::Text',
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required ValidCountryName /],
);

has_field released_at => (
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
        html => q{<div id="markdown-preview-summary" class="markdown summary markdown-preview">Summary preview here</div>},
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
        html => q{<div id="markdown-preview-full" class="markdown full markdown-preview">Full preview here</div>},
    },
);

has_button update_song => ();

override posted => sub {
	my $self = shift;

	my $user = $self->c->stash->{auth_user};

    # Whitelist what we extract from the submitted form
	my $fields = $self->form_hash(qw/ title album artist image country released_at summary_markdown full_markdown /);
	return $user->admin_edit_song($self->song, $fields);
};

# Prepopulate GET form from the song object
sub BUILD {
    my $self = shift;

 	$self->data_object($self->song);
}

__PACKAGE__->meta->make_immutable;
1;
