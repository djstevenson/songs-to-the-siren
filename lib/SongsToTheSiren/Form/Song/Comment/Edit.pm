package SongsToTheSiren::Form::Song::Comment::Edit;
use Moose;
use namespace::autoclean;

use SongsToTheSiren::Form::Moose;
extends 'SongsToTheSiren::Form::Base';
with 'SongsToTheSiren::Form::Role';

has '+id' => (default => 'edit-comment');

# The comment object that we are editing.
has comment => (is => 'ro', isa => 'SongsToTheSiren::Schema::Result::Comment', required => 1,);


has_field comment_bbcode => (
    type       => 'Input::TextArea',
    label      => 'Comment (plain text or BBEdit format)',
    autofocus  => 1,
    filters    => [qw/ TrimEdges /],
    validators => [qw/ Required  /],
);

has_field reason => (
    type       => 'Input::Text',
    label      => 'Reason for edit',
    filters    => [qw/ TrimEdges /],
    validators => [qw/ Required  /],
    options    => {initial_value => '',}
);

has_button submit => ();
has_button cancel => (style => 'light', skip_validation => 1);

override posted => sub {
    my $self = shift;

    my $submit_button = $self->find_button('submit');
    if ($submit_button->clicked) {

        my $user = $self->c->stash->{auth_user};

        # Whitelist what we extract from the submitted form
        my $fields = $self->form_hash(qw/ comment_bbcode reason /);

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
