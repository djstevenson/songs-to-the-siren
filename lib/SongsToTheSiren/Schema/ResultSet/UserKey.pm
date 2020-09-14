package SongsToTheSiren::Schema::ResultSet::UserKey;
use utf8;
use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';

use SongsToTheSiren::Util::Password qw/ new_password_hash /;

use DateTime;

# TODO POD


# Named args: user_id, key, purpose, duration
# Duration is a DateTime::Duration
# e.g. +1 hour to set an expiry one hour from now
sub create_key {
    my ($self, $args) = @_;

    my $key_hash    = new_password_hash($args->{key});
    my $expiry_time = DateTime->now->add_duration($args->{duration});
    my $user_id     = $args->{user_id};
    my $purpose     = $args->{purpose};

    # Obvs there's a race condition here, but we don't care that much.
    # The chances of one user generating two user_keys at the same time,
    # unless they're trying to hack something, are pretty small. If they're
    # hacking, I'm happy for this to generate exceptions for dupe records,
    # say. For this reason, I'm also not doing this in a transaction as I
    # don't want the delete rolled back if the create fails.

    $self->search({user_id => $user_id, purpose => $purpose,})->delete;

    return $self->create({user_id => $user_id, purpose => $purpose, key_hash => $key_hash, expires_at => $expiry_time,
    });
}

sub find_key {
    my ($self, $user, $purpose) = @_;

    return $self->find({user_id => $user->id, purpose => $purpose,});
}

__PACKAGE__->meta->make_immutable;
1;
