package NeverTire::Form::Content::Delete;
use Moose;
use namespace::autoclean;

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

has '+id' => (default => 'delete-content');

has content => (
    is          => 'ro',
    isa         => 'NeverTire::Schema::Result::Content',
    required    => 1,
);

has_button delete_content => ();
has_button cancel => (style => 'light');

override posted => sub {
	my $self = shift;
	
    my $delete_button = $self->find_button('delete_content');
    if ( $delete_button->clicked ) {
        $self->content->delete;
        return 'Content deleted';
    }

    return 'No action taken';
};

__PACKAGE__->meta->make_immutable;
1;
