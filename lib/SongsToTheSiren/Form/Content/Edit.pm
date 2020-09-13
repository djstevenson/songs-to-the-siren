package SongsToTheSiren::Form::Content::Edit;
use Moose;
use namespace::autoclean;

use SongsToTheSiren::Form::Moose;
extends 'SongsToTheSiren::Form::Base';
with 'SongsToTheSiren::Form::Role';

has '+id' => (default => 'edit-content');

has content => (is => 'ro', isa => 'SongsToTheSiren::Schema::Result::Content', predicate => 'is_update');

has_field title => (type => 'Input::Text', filters => [qw/ TrimEdges /], validators => [qw/ Required  /]);

has_field markdown => (
    label      => 'Summary',
    type       => 'Input::TextArea',
    filters    => [qw/ TrimEdges /],
    validators => [qw/ Required  /],
    data       => {'markdown-preview' => 'markdown-preview-content',},
);

has_field preview => (
    type    => 'Html',
    options => {html => q{<div id="markdown-preview-content" class="markdown markdown-preview">Preview here</div>},},
);

has_button submit => ();
has_button cancel => (style => 'light', skip_validation => 1);

override posted => sub {
    my $self = shift;

    my $update_button = $self->find_button('submit');
    if ($update_button->clicked) {

        my $user = $self->c->stash->{auth_user};

        # Whitelist what we extract from the submitted form
        my $fields = $self->form_hash(qw/ title markdown /);

        # Create or update?
        if ($self->is_update) {

            # Update
            $user->admin_edit_content($self->content, $fields);
            $self->action('updated');
        }
        else {
            # Create
            $user->admin_create_content($fields);
            $self->action('created');
        }
    }

    return 1;
};

# Prepopulate GET form from the content object
sub BUILD {
    my $self = shift;

    if ($self->is_update) {
        $self->data_object($self->content);
    }

    return;
}

__PACKAGE__->meta->make_immutable;
1;
