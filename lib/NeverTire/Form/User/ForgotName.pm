package NeverTire::Form::User::ForgotName;
use Moose;
use namespace::autoclean;

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

has '+id'     => (default => 'user-forgot-name');

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

has_button send_me_my_login_name => ();

override posted => sub {
	my $self = shift;

	my $email_field = $self->find_field('email');
	my $user_rs = $self->c->schema->resultset('User');
	my $user = $user_rs->find_by_email($email_field->value);

	$self->c->send_name_reminder($user)
		if $user;

	return 1;
};

__PACKAGE__->meta->make_immutable;
1;
