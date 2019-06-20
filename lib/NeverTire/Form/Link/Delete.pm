package NeverTire::Form::Link::Delete;
use Moose;
use namespace::autoclean;

# TODO Be more consistent.  Link forms are 
# under NT::Form::Link but link tables are
# under NT::Table::Song::Link  - ie one
# includes Song in the chain and one doesn't.

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

has '+id' => (default => 'delete-link');

has song => (
    is          => 'ro',
    isa         => 'NeverTire::Schema::Result::Song',
    required    => 1,
);

has link => (
    is          => 'ro',
    isa         => 'NeverTire::Schema::Result::Link',
    required    => 1,
);

has_button delete_link => ();
has_button cancel => (
    style => 'light',
);

override posted => sub {
	my $self = shift;
	
    my $delete_button = $self->find_button('delete_link');
    if ( $delete_button->clicked ) {
        $self->link->delete;
        return 'Song deleted';
    }

    return 'No action taken';
};

__PACKAGE__->meta->make_immutable;
1;
