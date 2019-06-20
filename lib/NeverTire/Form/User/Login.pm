package NeverTire::Form::User::Login;
use Moose;
use namespace::autoclean;

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

use NeverTire::Util::Password qw/ check_password_hash new_password_hash /;

has '+id'     => (default => 'user-login');

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

has_button login => ();

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

	my $fail;

	my $login_fail = 'Name and/or password incorrect';

    # TODO This needs a restructure. Method(s) in User
    #      resultset/result, for example
	my $user_rs = $self->c->schema->resultset('User');
	my $name_field = $self->find_field('name');
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
			$fail = $login_fail;
		}
	}
	else {
		# No user. Simulate a Bcrypt hashing operation to try
		# to thwart those who use timing to differentiate between
		# bad name and bad password.
		new_password_hash('dummy value');
		$fail = $login_fail;
	}

	# Set the error on 'name' if we don't already have one
	$name_field->error($fail)
		if $fail && !$name_field->has_error;
};

__PACKAGE__->meta->make_immutable;
1;
