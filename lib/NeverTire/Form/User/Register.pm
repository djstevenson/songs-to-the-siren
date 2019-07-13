package NeverTire::Form::User::Register;
use Moose;
use namespace::autoclean;

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

has '+id'     => (default => 'user-register');

has_field name => (
    type        => 'Input::Text',
    autofocus   => 1,
    filters     => [
		'TrimEdges',
		'SingleSpace',
	],
    validators  => [
		'Required',
		[ MinLength => {min => 3} ],
		[ MaxLength => {max => 30} ],
		'UniqueName',
	],
);

has_field email => (
    type        => 'Input::Email',
    filters     => [
		'TrimEdges',
	],
    validators  => [
    	'Required',
    	[ MaxLength => {max => 999} ],
    	'ValidEmail',
    	'UniqueEmail',
	],
);

has_field password => (
    type        => 'Input::Password',
    filters     => [],
    validators  => [
    	'Required',
    	[ MinLength => {min => 5} ],
    	[ MaxLength => {max => 99} ],
	],
);

has_button register => (id => 'user-register-button');

override posted => sub {
	my $self = shift;

	my $rs = $self->c->schema->resultset('User');
	my $user = $rs->register($self->form_hash(qw/ name email password /));

	$self->c->send_registration_email($user);

	return $user;
};

# TODO Tests
after extra_validation => sub {
	my $self = shift;

	my $name_field     = $self->find_field('name');
    my $name_value     = lc $name_field->value;
	my $password_field = $self->find_field('password');
    my $password_value = lc $password_field->value;

    my $fail;

    $fail = 'Password must not contain user name'
        if index($password_value, $name_value) != -1;

	# Set the error on 'name' if we don't already have one
	$password_field->error($fail)
		if $fail && !$password_field->has_error;
};

__PACKAGE__->meta->make_immutable;
1;
