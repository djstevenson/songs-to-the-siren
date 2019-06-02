package NeverTire::Schema::ResultSet::User;
use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';

use NeverTire::Util::Password qw/ new_password_hash /;

use DateTime;

# TODO POD

sub create_user {
	my ($self, $args) = @_;

	my $passwd = new_password_hash($args->{password});

	my $now = DateTime->now;

	my $user = $self->create({
		name          => lc($args->{name}),
		email         => lc($args->{email}),
		password_hash => $passwd,
		date_created  => $now,
		date_password => $now,
		admin         => $args->{admin} // 0,
	});

	# TODO Users should confirm
	# TODO Probably don't set password here when we
	#      create the user, but get them to set one
	#      when they confirm.
	# TODO Or, make this an initial password that
	#      is marked as expired, so they have to 
	#      change it when they log in.
	# $user->send_registration_email;

	return $user;
}


sub find_by_email{
	my ($self, $email) = @_;

	return $self->search(
		\[ 'LOWER(email) = ?', [ plain_value => lc($email) ] ],
		{
			rows => 1
		}
	)->first;
}

sub find_by_name{
	my ($self, $name) = @_;

	return $self->search(
		\[ 'LOWER(name) = ?', [ plain_value => lc($name) ] ],
		{
			rows => 1
		}
	)->first;
}

__PACKAGE__->meta->make_immutable;
1;
