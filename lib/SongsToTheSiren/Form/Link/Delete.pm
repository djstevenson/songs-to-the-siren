package SongsToTheSiren::Form::Link::Delete;
use Moose;
use namespace::autoclean;

# TODO Be more consistent.  Link forms are
# under STTS::Form::Link but link tables are
# under STTS::Table::Song::Link  - ie one
# includes Song in the chain and one doesn't.

use SongsToTheSiren::Form::Moose;
extends 'SongsToTheSiren::Form::Base';
with 'SongsToTheSiren::Form::Role';

has '+id' => (default => 'delete-link');

has song => (is => 'ro', isa => 'SongsToTheSiren::Schema::Result::Song', required => 1);

has link => (is => 'ro', isa => 'SongsToTheSiren::Schema::Result::Link', required => 1);

has_button delete_link => ();
has_button cancel      => (style => 'light');

override posted => sub {
    my $self = shift;

    my $delete_button = $self->find_button('delete_link');
    if ($delete_button->clicked) {
        $self->link->delete;
        return 'Song deleted';
    }

    return 'No action taken';
};

__PACKAGE__->meta->make_immutable;
1;
