package SongsToTheSiren::Form::Song::Comment::Reject;
use Moose;
use namespace::autoclean;

use SongsToTheSiren::Form::Moose;
extends 'SongsToTheSiren::Form::Base';
with 'SongsToTheSiren::Form::Role';

has '+id' => (default => 'reject-comment');

has comment => (
    is          => 'ro',
    isa         => 'SongsToTheSiren::Schema::Result::Comment',
    required    => 1,
);

has_button reject_comment => ();
has_button cancel => (style => 'light');

override posted => sub {
	my $self = shift;
	
    my $approve_button = $self->find_button('reject_comment');
    if ( $approve_button->clicked ) {
        my $user = $self->c->stash->{auth_user};
        $user->reject_comment($self->comment);

        return 'Comment rejected';
    }

    return 'No action taken';
};

__PACKAGE__->meta->make_immutable;
1;
