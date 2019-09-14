package NeverTire::Form::Song::Comment::Approve;
use Moose;
use namespace::autoclean;

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

has '+id' => (default => 'approve-comment');

has comment => (
    is          => 'ro',
    isa         => 'NeverTire::Schema::Result::Comment',
    required    => 1,
);

has_button approve_comment => ();
has_button cancel => (style => 'light');

override posted => sub {
	my $self = shift;
	
    my $approve_button = $self->find_button('admin_approve_comment');
    if ( $approve_button->clicked ) {
        my $user = $self->c->stash->{auth_user};
        $user->approve_comment($self->comment);

        return 'Comment approved';
    }

    return 'No action taken';
};

__PACKAGE__->meta->make_immutable;
1;
