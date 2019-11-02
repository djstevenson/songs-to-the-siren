package NeverTire::Form::Song::Delete;
use Moose;
use namespace::autoclean;

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

has '+id' => (default => 'delete-song');

has song => (
    is          => 'ro',
    isa         => 'NeverTire::Schema::Result::Song',
    required    => 1,
);

has_button delete_song => ();
has_button cancel => (style => 'light', skip_validation => 1);

# TODO maybe implement these as callbacks on the buttons?
override posted => sub {
	my $self = shift;
	
    my $delete_button = $self->find_button('delete_song');
    if ( $delete_button->clicked ) {
        $self->song->delete;
        $self->action('deleted');
    }

    return 1;
};

__PACKAGE__->meta->make_immutable;
1;
