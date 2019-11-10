package NeverTire::Form::Link::Edit;
use Moose;
use namespace::autoclean;

# TODO Loadsa dupe code with Link::Create form, can we put most of this in a base class or something?

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

has '+id' => (default => 'edit-link');

has_field identifier => (
    type        => 'Input::Text',
    autofocus   => 1,
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required /],
);

has_field class => (
    type        => 'Input::Text',
    autofocus   => 1,
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required /],
);

# TODO Add URL validation
has_field url => (
    type        => 'Input::Text',
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
);

has_field priority => (
    type        => 'Input::Text',
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  ValidInteger /],
);

has_field description => (
    type        => 'Input::Text',
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
);

has_field extras => (
    type        => 'Input::Text',
    filters     => [qw/ TrimEdges /],
);

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

has_button update_link => ();
has_button cancel => (style => 'light', skip_validation => 1);

# Identifier must not already exist for this song. However,
# if we're not changing it in this edit, then it'll already exist
# in this link. So the check is "does it exist in this song for
# any other link"
after extra_validation => sub {
    my $self = shift;

    my $fail;

    my $identifiers = $self->c
        ->schema->resultset('Link')
        ->for_song($self->song)
        ->links_by_identifier;
    
    my $identifier_field = $self->find_field('identifier');
    my $identifier_value = lc $identifier_field->value;

    $fail = 'Identifier already used for this song'
        if exists $identifiers->{$identifier_value}
            && $identifiers->{$identifier_value}->id != $self->link->id;

    # Set the error on 'identifier' if we don't already have one
    $identifier_field->error($fail)
        if $fail && !$identifier_field->has_error;
};

override posted => sub {
	my $self = shift;

    my $update_button = $self->find_button('update_link');
    if ( $update_button->clicked ) {
        # Whitelist what we extract from the submitted form
        my $fields = $self->form_hash(qw/ identifier class url description priority extras /);
        $self->link->update($fields);
        $self->action('updated');
    }

    return 1;
};

# Prepopulate GET form from the song object
sub BUILD {
    my $self = shift;

 	$self->data_object($self->link);
}

__PACKAGE__->meta->make_immutable;
1;
