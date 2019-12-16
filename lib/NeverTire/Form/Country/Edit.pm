package NeverTire::Form::Country::Edit;
use Moose;
use namespace::autoclean;

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

has '+id' => (default => 'edit-country');

has country => (
    is          => 'ro',
    isa         => 'NeverTire::Schema::Result::Country',
    predicate   => 'is_update',
);

has_field name => (
    type        => 'Input::Text',
    autofocus   => 1,
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required /],
);

has_field emoji => (
    type        => 'Input::Text',
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
);

has_button submit => ();
has_button cancel => (style => 'light', skip_validation => 1);

override posted => sub {
	my $self = shift;

    my $update_button = $self->find_button('submit');
    if ( $update_button->clicked ) {

        my $user = $self->c->stash->{auth_user};

        # Whitelist what we extract from the submitted form
    	my $fields = $self->form_hash(qw/ name emoji /);
    
        # Create or update?
        if ( $self->is_update ) {
            # Update
	        $user->admin_edit_country($self->country, $fields);
            $self->action('updated');
        }
        else {
            # Create
            $user->admin_create_country($fields);
            $self->action('created');
        }
    }

    return 1;
};

# Prepopulate GET form from the content object
sub BUILD {
    my $self = shift;

    if ( $self->is_update ) {
        $self->data_object($self->country);
    }
}

__PACKAGE__->meta->make_immutable;
1;
