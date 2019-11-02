package NeverTire::Form::Country::Create;
use Moose;
use namespace::autoclean;

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

has '+id' => (default => 'new-country');

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

has_button create_country => ();
has_button cancel => (style => 'light', skip_validation => 1);

override posted => sub {
	my $self = shift;

    my $create_button = $self->find_button('create_country');
    if ( $create_button->clicked ) {
        my $user = $self->c->stash->{auth_user};

        # Whitelist what we extract from the submitted form
    # Whitelist what we extract from the submitted form
        my $fields = $self->form_hash(qw/ name emoji /);
        $user->admin_create_country($fields);
        $self->action('created');
    }

    return 1;
};

__PACKAGE__->meta->make_immutable;
1;
