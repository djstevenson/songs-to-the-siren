package NeverTire::Form::Song::Delete::All;
use Moose;
use namespace::autoclean;

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

has '+id' => (default => 'delete-all-songs');

has_button delete_all_songs => ();
has_button cancel => (style => 'light');

# TODO maybe implement these as callbacks on the buttons?
override posted => sub {
	my $self = shift;
	
    my $delete_button = $self->find_button('delete_all_songs');
    if ( $delete_button->clicked ) {
        my $schema = $self->c->schema;
        $schema->resultset('Song')->delete;
        $schema->resultset('Tag')->delete;
        $schema->resultset('User')->delete;

        return 'Songs/tags/users/etc deleted';
    }

    return 'No action taken';
};

__PACKAGE__->meta->make_immutable;
1;
