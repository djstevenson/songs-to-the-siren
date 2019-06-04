package NeverTire::Schema::Role::User::Auth;
use Moose::Role;

# TODO Add pod

use DateTime;
use DateTime::Duration;
use NeverTire::Util::Password qw/ random_user_key /;


# This exists just to keep Result::User down to a more managable size.
# It extracts the methods relating to authentication, key management, etc

sub generate_new_user_key {
    my ($self, $purpose, $duration) = @_;

    # TODO Sort out exports from NeverTire::Util::Password
    my $key = random_user_key();

    my $user_key_rs = $self->result_source->schema->resultset('UserKey');
    $user_key_rs->create_key({
        user_id  => $self->id,
        key      => $key,
        purpose  => $purpose,
        duration => $duration,
    });

    # Yes, returns the plain text key, not the hash. This is what
    # we need to embed in (say) registration emails
    return $key;
}

sub send_registration_email {
    my $self = shift;

    my $purpose = 'registration';
    my $duration = DateTime::Duration->new(hours => 1); # TODO Configurable
    my $user_key = $self->generate_new_user_key($purpose, $duration);

    $self->send_email($purpose, {
        user => $self->id,
        key  => $user_key,
    });
}

sub send_email {
    my ($self, $template_name, $data) = @_;

    my $email_rs = $self->result_source->schema->resultset('Email');
    $email_rs->create({
        email_from    => 'noreply@ytfc.com', # TODO Make configurable
        email_to      => lc($self->email),
        template_name => $template_name,
        data          => $data,
        queued_at     => DateTime->now,
    });
}



no Moose::Role;
1;

