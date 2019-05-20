package NeverTire::Schema::Result::User;
use Moose;
use namespace::autoclean;

extends 'NeverTire::Schema::Base::Result';

# TODO POD

use DateTime;
use Text::Markdown qw/ markdown /;

__PACKAGE__->load_components('InflateColumn::DateTime');

__PACKAGE__->table('users');

__PACKAGE__->add_columns(
    id            => {data_type => 'INTEGER'},
    name          => {data_type => 'TEXT'},
    email         => {data_type => 'TEXT'},
    password_hash => {data_type => 'TEXT'},   # Bcrypt 2a with random salt
    date_created  => {data_type => 'DATETIME'},
    date_password => {data_type => 'DATETIME'},
);

__PACKAGE__->set_primary_key('id');

# Relation for the song descriptions created by this user.
__PACKAGE__->has_many(song => 'NeverTire::Schema::Result::Song', { 'foreign.author_id' => 'self.id' });


sub create_song {
    my ($self, $args) = @_;

    # TODO Render html properly!
    $args->{html}         = markdown($args->{markdown});
    $args->{date_created} = DateTime->now;
    return $self->create_related('song', $args);
}

sub edit_song {
    my ($self, $song, $args) = @_;

    # TODO Render html properly!
    $args->{html}         = markdown($args->{markdown});
    $args->{date_updated} = DateTime->now;
    $song->update($args);
    return $song;
}

no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;
