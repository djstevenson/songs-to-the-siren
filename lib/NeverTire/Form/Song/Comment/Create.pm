package NeverTire::Form::Song::Comment::Create;
use Moose;
use namespace::autoclean;

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

has '+id' => (default => 'new-comment');

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

has_button submit => ();
has_button cancel => (style => 'light', skip_validation => 1);

has song => (
    is          => 'ro',
    isa         => 'NeverTire::Schema::Result::Song',
    required    => 1,
);

has parent_comment => (
    is          => 'ro',
    isa         => 'NeverTire::Schema::Result::Comment',
    predicate   => 'has_parent_comment',
);

override posted => sub {
	my $self = shift;

    my $submit_button = $self->find_button('submit');
    if ( $submit_button->clicked ) {
        
        my $user = $self->c->stash->{auth_user};

        # Whitelist what we extract from the submitted form
        my $fields = $self->form_hash(qw/ comment_markdown /);

        my $parent = $self->has_parent_comment ? $self->parent_comment : undef;
        $user->new_song_comment($self->song, $parent, $fields);
    }

    return 1;
};

__PACKAGE__->meta->make_immutable;
1;
