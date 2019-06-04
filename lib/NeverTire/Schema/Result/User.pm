package NeverTire::Schema::Result::User;
use Moose;
use namespace::autoclean;

extends 'NeverTire::Schema::Base::Result';

# TODO POD

use NeverTire::Util::Password qw/ random_user_key /;

use DateTime;
use Text::Markdown qw/ markdown /;
use Carp qw/ croak /;

__PACKAGE__->load_components('InflateColumn::DateTime');

__PACKAGE__->table('users');

__PACKAGE__->add_columns(
    id            => {data_type => 'INTEGER'},
    name          => {data_type => 'TEXT'},
    email         => {data_type => 'TEXT'},
    password_hash => {data_type => 'TEXT'},   # Bcrypt 2a with random salt
    admin         => {data_type => 'BOOLEAN'},
    registered_at => {data_type => 'DATETIME'},
    confirmed_at  => {data_type => 'DATETIME'},
    password_at   => {data_type => 'DATETIME'},
);

__PACKAGE__->set_primary_key('id');

# Relation for the song descriptions created by this user.
__PACKAGE__->has_many(songs => 'NeverTire::Schema::Result::Song', { 'foreign.author_id' => 'self.id' });


sub create_song {
    my ($self, $args) = @_;

    croak 'Permission denied' unless $self->admin;

    my $full_args = {
        %$args,
        full_html    => markdown($args->{full_markdown}),
        summary_html => markdown($args->{summary_markdown}),
        date_created => DateTime->now,
    };

    return $self->create_related('songs', $full_args);
}

sub edit_song {
    my ($self, $song, $args) = @_;

    croak 'Permission denied' unless $self->admin;

    my $full_args = {
        %$args,
        full_html    => markdown($args->{full_markdown}),
        summary_html => markdown($args->{summary_markdown}),
        date_updated => DateTime->now,
    };

    # TODO Record who did the update
    $song->update($full_args);
    
    return $song;
}

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

no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;
