package NeverTire::Form::Content::Edit;
use Moose;
use namespace::autoclean;

# TODO Loadsa dupe code with Content::Create form, can we put most of this in a base class or something?

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

has '+id' => (default => 'edit-content');

has content => (
    is          => 'ro',
    isa         => 'NeverTire::Schema::Result::Content',
    required    => 1,
);

has_field title => (
    type        => 'Input::Text',
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
);

has_field markdown => (
    label       => 'Summary',
    type        => 'Input::TextArea',
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
);

has_field preview => (
    type        => 'Html',
    options     => {
        html => q{<div id="markdown-content-preview" class="markdown markdown-preview">Preview here</div>},
    },
);

has_button update_content => ();

override posted => sub {
	my $self = shift;

	my $user = $self->c->stash->{auth_user};

    # Whitelist what we extract from the submitted form
	my $fields = $self->form_hash(qw/ title markdown /);
	return $user->admin_edit_content($self->content, $fields);
};

# Prepopulate GET form from the content object
sub BUILD {
    my $self = shift;

    $self->data_object($self->content);
}

__PACKAGE__->meta->make_immutable;
1;
