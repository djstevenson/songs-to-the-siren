package SongsToTheSiren::Form::Content::Delete;
use utf8;
use Moose;
use namespace::autoclean;

use SongsToTheSiren::Form::Moose;
extends 'SongsToTheSiren::Form::Base';
with 'SongsToTheSiren::Form::Role';

has '+id' => (default => 'delete-content');

has content => (is => 'ro', isa => 'SongsToTheSiren::Schema::Result::Content', required => 1);

has_button delete_content => ();
has_button cancel         => (style => 'light', skip_validation => 1);

override posted => sub {
    my $self = shift;

    my $delete_button = $self->find_button('delete_content');
    if ($delete_button->clicked) {
        $self->content->delete;
        $self->action('deleted');
    }

    return 1;
};

__PACKAGE__->meta->make_immutable;
1;
