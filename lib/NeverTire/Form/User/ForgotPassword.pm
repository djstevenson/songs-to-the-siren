package NeverTire::Form::User::ForgotPassword;
use Moose;
use namespace::autoclean;

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

has '+legend' => (default => 'Password reset');
has '+id'     => (default => 'user-forgot-password');

has_field email => (
    type        => 'Input::Email',
    autofocus   => 1,
    filters     => [
		'TrimEdges',
	],
    validators  => [
    	'Required',
    	[ MaxLength => {max => 999} ],
    	'ValidEmail',
	],
);

has_button login => (
	label => 'Request password reset',
);

override posted => sub {
	my $self = shift;

	my $email_field = $self->find_field('email');
	my $user_rs = $self->c->schema->resultset('User');
	my $user = $user_rs->find_by_email($email_field->value);

	if ($user) {
		$user->send_password_reset;
	}
	return 1;
};

__PACKAGE__->meta->make_immutable;
1;
