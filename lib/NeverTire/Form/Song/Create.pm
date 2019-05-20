package NeverTire::Form::Song::Create;
use Moose;
use namespace::autoclean;

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

has '+submit_label' => (default => 'New song');
has '+id'           => (default => 'new-song');

has_field title => (
    type        => 'Input::Text',
    autofocus   => 1,
    filters     => [qw/
        TrimEdges
	/],
    validators  => [qw/
		Required
	/],
);

has_field album => (
    type        => 'Input::Text',
    filters     => [qw/
        TrimEdges
	/],
    validators  => [qw/
		Required
	/],
);

# TODO At the moment, artists are in a separate table.
#      Change that cos we're not gonna do a whole load of
#      tracks from one artist.
has_field artist => (
    type        => 'Input::Text',
    filters     => [qw/
        TrimEdges
	/],
    validators  => [qw/
		Required
	/],
);

has_field date_released => (
    label       => 'Date Released',
    type        => 'Input::Text',
    filters     => [qw/
        TrimEdges
	/],
    validators  => [qw/
		Required
	/],
);


has_field markdown => (
    label       => 'Description',
    type        => 'Input::TextArea',
    filters     => [qw/
        TrimEdges
	/],
    validators  => [qw/
		Required
	/],
);


override posted => sub {
	my $self = shift;

	my $user = $self->c->stash->{auth_user};

    # Whitelist what we extract from the submitted form
	my $fields = $self->form_hash(qw/ title album artist date_released markdown /);
	return $user->create_song($fields);
};

__PACKAGE__->meta->make_immutable;
1;
