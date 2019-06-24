package NeverTire::Form::Song::Comment::Create;
use Moose;
use namespace::autoclean;

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

has '+id' => (default => 'new-song-comment');

has_field markdown => (
    type        => 'Input::TextArea',
    label       => 'Comment (plain text or Markdown format)',
    autofocus   => 1,
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
);

has_field comment_preview => (
    type        => 'Html',
    options     => {
        html => q{<div id="markdown-preview-comment" class="markdown comment markdown-preview">Comment preview here</div>},
    },
);

has_button add_comment => ();

override posted => sub {
	my $self = shift;

    die "NYI";
	# my $user = $self->c->stash->{auth_user};

    # # Whitelist what we extract from the submitted form
	# my $fields = $self->form_hash(qw/ title artist album country_id released_at summary_markdown full_markdown /);
	# return $user->admin_create_song($fields);
};

__PACKAGE__->meta->make_immutable;
1;
