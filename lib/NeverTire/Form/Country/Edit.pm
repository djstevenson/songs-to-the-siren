package NeverTire::Form::Country::Edit;
use Moose;
use namespace::autoclean;

# TODO Loadsa dupe code with Country::Create form, can we put most of this in a base class or something?

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

has '+id' => (default => 'edit-country');

has country => (
    is          => 'ro',
    isa         => 'NeverTire::Schema::Result::Country',
    required    => 1,
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

has_button update_country => ();
has_button cancel => (style => 'light', skip_validation => 1);

override posted => sub {
	my $self = shift;

    my $update_button = $self->find_button('update_country');
    if ( $update_button->clicked ) {
        my $user = $self->c->stash->{auth_user};

    	my $fields = $self->form_hash(qw/ name emoji /);
	    $user->admin_edit_country($self->country, $fields);
        $self->action('updated');
    }

    return 1;
};

# Prepopulate GET form from the content object
sub BUILD {
    my $self = shift;

    $self->data_object($self->country);
}

__PACKAGE__->meta->make_immutable;
1;
