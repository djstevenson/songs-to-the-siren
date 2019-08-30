package NeverTire::Form::Page::Delete;
use Moose;
use namespace::autoclean;

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

has '+id' => (default => 'delete-pagea');

has page => (
    is          => 'ro',
    isa         => 'NeverTire::Schema::Result::Page',
    required    => 1,
);

has_button delete_page => ();
has_button cancel => (style => 'light');

override posted => sub {
	my $self = shift;
	
    my $delete_button = $self->find_button('delete_page');
    if ( $delete_button->clicked ) {
        $self->page->delete;
        return 'Page deleted';
    }

    return 'No action taken';
};

__PACKAGE__->meta->make_immutable;
1;
