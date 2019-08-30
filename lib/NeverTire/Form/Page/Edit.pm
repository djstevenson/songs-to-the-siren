package NeverTire::Form::Page::Edit;
use Moose;
use namespace::autoclean;

# TODO Loadsa dupe code with Page::Create form, can we put most of this in a base class or something?

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

has '+id' => (default => 'edit-page');

has page => (
    is          => 'ro',
    isa         => 'NeverTire::Schema::Result::Page',
    required    => 1,
);

has_field name => (
    type        => 'Input::Text',
    autofocus   => 1,
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required /],
    # TODO Kinda want a "unique name other than this page itself validation".
    # TODO Or don't let them edit the name. Use it as a primary key?
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
        html => q{<div id="markdown-page-preview" class="markdown markdown-preview">Preview here</div>},
    },
);

has_button update_page => ();

override posted => sub {
	my $self = shift;

	my $user = $self->c->stash->{auth_user};

    # Whitelist what we extract from the submitted form
	my $fields = $self->form_hash(qw/ name title markdown /);
	return $user->admin_edit_page($self->page, $fields);
};

# Prepopulate GET form from the page object
sub BUILD {
    my $self = shift;

    $self->data_object($self->page);
}

__PACKAGE__->meta->make_immutable;
1;
