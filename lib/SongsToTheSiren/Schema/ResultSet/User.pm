package SongsToTheSiren::Schema::ResultSet::User;
use utf8;
use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';

use SongsToTheSiren::Util::Password qw/ new_password_hash /;

use DateTime;
use Carp;

# TODO POD

# TODO Dupe user creation methods
# This one bypasses the registration confirmation, so drop it
# (except maybe for creating initial admin user?)
sub create_user {
    my ($self, $args) = @_;

    my $passwd = new_password_hash($args->{password});

    my $now = DateTime->now;

    my $user = $self->create({
        name          => lc($args->{name}),
        email         => lc($args->{email}),
        password_hash => $passwd,
        registered_at => $now,
        confirmed_at  => $now,
        password_at   => $now,
        admin         => $args->{admin} // 0,
    });

    # TODO Users should confirm
    # TODO Probably don't set password here when we
    #      create the user, but get them to set one
    #      when they confirm.
    # TODO Or, make this an initial password that
    #      is marked as expired, so they have to
    #      change it when they log in.

    return $user;
}

sub register {
    my ($self, $args) = @_;

    my $passwd = new_password_hash($args->{password});

    my $now = DateTime->now;
    return $self->create({
        name          => $args->{name},
        email         => lc($args->{email}),
        password_hash => $passwd,
        registered_at => $now,
        password_at   => $now,
    });
}

sub find_by_email {
    my ($self, $email) = @_;

    return $self->search(\['LOWER(email) = ?', [plain_value => lc($email)]], {rows => 1})->first;
}

sub find_by_name {
    my ($self, $name) = @_;

    return $self->search(\['LOWER(name) = ?', [plain_value => lc($name)]], {rows => 1})->first;
}

sub admin_users {
    my ($self) = @_;

    return $self->search({admin => 1});
}

##########################
## TEST-RELATED METHODS ##
##########################


# TODO Split test methods off into a role?
sub create_test_user {
    my ($self, $username, $email, $password, $admin) = @_;

    $self->assert_test_db;

    my $passwd = new_password_hash($password);

    my $now  = DateTime->now;
    my $user = $self->create({
        name          => $username,
        email         => $email,
        password_hash => $passwd,
        admin         => $admin ? 1 : 0,
        registered_at => $now,
        confirmed_at  => $now,
        password_at   => $now,
    });

    return $user;
}

sub assert_test_db {
    my $self = shift;

    croak unless $ENV{MOJO_MODE} eq 'test';

    my $schema = $self->result_source->schema;
    my $dbh    = $schema->storage->dbh;

    my ($k, $name) = split(/=/, $dbh->{Name});
    croak unless $name eq 'songstothesiren_test';

    return;
}

__PACKAGE__->meta->make_immutable;
1;
