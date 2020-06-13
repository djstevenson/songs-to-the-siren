package SongsToTheSiren::Form::Song::Comment::Approve;
use Moose;
use namespace::autoclean;

use SongsToTheSiren::Form::Moose;
extends 'SongsToTheSiren::Form::Base';
with 'SongsToTheSiren::Form::Role';

has '+id' => (default => 'approve-comment');

has comment => (is => 'ro', isa => 'SongsToTheSiren::Schema::Result::Comment', required => 1,);

has_button approve_comment => ();
has_button cancel          => (style => 'light');

override posted => sub {
    my $self = shift;

    my $approve_button = $self->find_button('approve_comment');
    if ($approve_button->clicked) {
        my $user = $self->c->stash->{auth_user};
        $user->approve_comment($self->comment);

        return 'Comment approved';
    }

    return 'No action taken';
};

__PACKAGE__->meta->make_immutable;
1;
