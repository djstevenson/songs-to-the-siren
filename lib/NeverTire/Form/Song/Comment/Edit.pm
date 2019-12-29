package NeverTire::Form::Song::Comment::Edit;
use Moose;
use namespace::autoclean;

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

has '+id' => (default => 'edit-comment');

# The comment object that we are editing.
has comment => (
    is          => 'ro',
    isa         => 'NeverTire::Schema::Result::Comment',
    required    => 1,
);


has_field comment_markdown => (
    type        => 'Input::TextArea',
    label       => 'Comment (plain text or Markdown format)',
    autofocus   => 1,
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
    data        => {
        'markdown-preview' => 'markdown-preview-comment',
    },
);

has_field comment_preview => (
    type        => 'Html',
    options     => {
        html => q{<div id="markdown-preview-comment" class="markdown comment markdown-preview">Comment preview here</div>},
    },
);

has_field reason => (
    type        => 'Input::Text',
    label       => 'Reason for edit',
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
    options     => {
        initial_value => '',
    }
);

has_button submit => ();
has_button cancel => (style => 'light', skip_validation => 1);

override posted => sub {
	my $self = shift;

    my $submit_button = $self->find_button('submit');
    if ( $submit_button->clicked ) {
        
        my $user = $self->c->stash->{auth_user};

        # Whitelist what we extract from the submitted form
        my $fields = $self->form_hash(qw/ comment_markdown reason /);

        $user->edit_song_comment($self->comment, $fields);
    }

    return 1;
};

# Prepopulate GET form from the comment object
sub BUILD {
    my $self = shift;

    $self->data_object($self->comment);
}


__PACKAGE__->meta->make_immutable;
1;
