package NeverTire::Schema::Result::User;
use Moose;
use namespace::autoclean;

extends 'NeverTire::Schema::Base::Result';

# TODO POD

use DateTime;
use Text::Markdown qw/ markdown /;
use Carp qw/ croak /;

# Bring in methods that we split out. We did that to keep
# file sizes more managable, and to group related methods
with 'NeverTire::Schema::Role::User::Auth';

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

no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;
