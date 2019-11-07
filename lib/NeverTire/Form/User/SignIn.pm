package NeverTire::Form::User::SignIn;
use Moose;
use namespace::autoclean;

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

use NeverTire::Util::Password qw/ check_password_hash new_password_hash /;

has '+id'     => (default => 'user-sign-in');

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

has_button sign_in => ();

has _save_user => (
    is          => 'rw',
	isa         => 'NeverTire::Schema::Result::User',
	predicate   => '_has_save_user',
	init_arg    => undef,
	clearer     => '_clear_save_user',
);

override posted => sub{
	my $self = shift;

	return $self->_save_user if $self->_has_save_user;

	return undef;
};

# TODO Tests
after extra_validation => sub {
	my $self = shift;

	$self->_clear_save_user;

	# Do nothing if we've already shown any errors
	my $name_field = $self->find_field('name');
	my $password_field = $self->find_field('password');
	return if $name_field->has_error || $password_field->has_error;

	my $fail; # Will be set to $sign_in_fail if needed

	my $sign_in_fail = 'Name and/or password incorrect';

    # TODO This needs a restructure. Method(s) in User
    #      resultset/result, for example
	my $user_rs = $self->c->schema->resultset('User');
	my $user = $user_rs->find_by_name($name_field->value);
	if ( $user ) {
		my $password_field = $self->find_field('password');
		my $plain = $password_field->value;
		my $hash  = $user->password_hash;
		if ( check_password_hash($plain, $hash) ) {
			# Password ok
			$self->_save_user($user);
		}
		else {
			$fail = $sign_in_fail;
		}
	}
	else {
		# No user. Simulate a Bcrypt hashing operation to try
		# to thwart those who use timing to differentiate between
		# bad name and bad password.
		new_password_hash('dummy value');
		$fail = $sign_in_fail;
	}

	# Set the error on 'name'
	$name_field->error($fail)
		if $fail;
};

__PACKAGE__->meta->make_immutable;
1;
