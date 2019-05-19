package NeverTire::Form::User::ConfirmBan;
use Moose;
use namespace::autoclean;

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

has '+submit_label' => (default => 'Confirm ban');
has '+id'           => (default => 'user_ban');

has_field reason => (
    type        => 'Input::Text',
    autofocus   => 1,
    filters     => [
		'TrimEdges',
		'SingleSpace',
	],
    validators  => [
		'Required',
		[ MinLength => {min => 3} ],
		[ MaxLength => {max => 200} ],
	],
);

override posted => sub {
    my $self = shift;

	# If form is submitted, that's a confirmation.
    # TODO add a cancel button, but for now assume they'll navigate away
    # TODO Make the button btn-danger

    my $auth_user   = $self->c->stash->{auth_user};
    my $target_user = $self->c->stash->{target_user};

    die unless $auth_user->admin;

    my $values = $self->form_hash(qw/ reason /);
    my $reason = $values->{reason};
    $auth_user->ban_user($target_user, $reason);
	return 1;
};


__PACKAGE__->meta->make_immutable;
1;
