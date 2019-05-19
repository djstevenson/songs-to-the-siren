package NeverTire::Form::User::ResetPassword;
use Moose;
use namespace::autoclean;

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

has '+submit_label' => (default => 'Set new password');
has '+id'           => (default => 'user-new-password');

has_field password => (
    type        => 'Input::Password',
    label       => 'New password',
    placeholder => 'New password',
    autofocus   => 1,
    filters     => [],
    validators  => [
        'Required',
        [ MinLength => {min => 5} ],
        [ MaxLength => {max => 99} ],
	],
);

# TODO Tests
after extra_validation => sub {
	my $self = shift;

	my $user_rs        = $self->c->schema->resultset('User');
    my $user           = $user_rs->find($self->c->stash->{user_id});
    my $name_value     = lc $user->name;
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