package SongsToTheSiren::Form::Song::Comment::Create;
use Moose;
use namespace::autoclean;

use SongsToTheSiren::Form::Moose;
extends 'SongsToTheSiren::Form::Base';
with 'SongsToTheSiren::Form::Role';

has '+id' => (default => 'new-comment');

has_field comment_bbcode => (
    type        => 'Input::TextArea',
    label       => 'Comment (plain text or BBCode format)',
    autofocus   => 1,
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
);

has_button submit => ();
has_button cancel => (style => 'light', skip_validation => 1);

has song => (
    is          => 'ro',
    isa         => 'SongsToTheSiren::Schema::Result::Song',
    required    => 1,
);

has parent_comment => (
    is          => 'ro',
    isa         => 'SongsToTheSiren::Schema::Result::Comment',
    predicate   => 'has_parent_comment',
);

override posted => sub {
	my $self = shift;

    my $submit_button = $self->find_button('submit');
    if ( $submit_button->clicked ) {
        
        my $user = $self->c->stash->{auth_user};

        # Whitelist what we extract from the submitted form
        my $fields = $self->form_hash(qw/ comment_bbcode /);

        my $parent = $self->has_parent_comment ? $self->parent_comment : undef;
        my $comment = $user->new_song_comment($self->song, $parent, $fields);
        $self->c->send_comment_notification($comment);
    }

    return 1;
};

__PACKAGE__->meta->make_immutable;
1;
