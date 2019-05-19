package NeverTire::Form::User::ConfirmUnban;
use Moose;
use namespace::autoclean;

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

has '+submit_label' => (default => 'Confirm revoking of ban');
has '+id'           => (default => 'user_unban');

override posted => sub {
    my $self = shift;

	# If form is submitted, that's a confirmation.
    # TODO add a cancel button, but for now assume they'll navigate away
    # TODO Make the button btn-danger

    my $auth_user   = $self->c->stash->{auth_user};
    my $target_user = $self->c->stash->{target_user};

    die unless $auth_user->admin;

    $auth_user->unban_user($target_user);
	return 1;
};


__PACKAGE__->meta->make_immutable;
1;
