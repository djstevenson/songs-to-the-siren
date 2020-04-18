package SongsToTheSiren::Form::Song::Edit;
use Moose;
use namespace::autoclean;


use SongsToTheSiren::Form::Moose;
extends 'SongsToTheSiren::Form::Base';
with 'SongsToTheSiren::Form::Role';

has '+id' => (default => 'edit-song');

has song => (
    is          => 'ro',
    isa         => 'SongsToTheSiren::Schema::Result::Song',
    predicate   => 'is_update',
);

has_field title => (
    type        => 'Input::Text',
    autofocus   => 1,
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
);

has_field artist => (
    type        => 'Input::Text',
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
);

has_field album => (
    type        => 'Input::Text',
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
);

has_field image => (
    type           => 'Input::Text',
    filters        => [qw/ TrimEdges /],
    validators     => [qw/ Required  /],
    autocomplete   => 'off',
    spellcheck     => 'false',
    autocapitalize => 'off',
);

has_field max_resolution => (
    type        => 'Select',
    label       => 'Max Resolution',
    selections  => sub {

        return [
            map { { value => $_, text => $_ . 'x' } } 1 .. 4
        ];
    },
);

has_field country_id => (
    type        => 'Select',
    label       => 'Country',
    selections  => sub {
        my ($field, $form) = @_;

        return $form->c->schema
            ->resultset('Country')
            ->as_select_options;
    },
);

has_field released_at => (
    label       => 'Date Released',
    type        => 'Input::Text',
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
);


has_field summary_markdown => (
    label       => 'Summary',
    type        => 'Input::TextArea',
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
    data        => sub {
        my ($field, $form) = @_;

        return $form->_markdown_field_data('summary');
    },
);

has_field summary_preview => (
    type        => 'Html',
    options     => {
        html => q{<div id="markdown-preview-summary" class="markdown summary markdown-preview"></div>},
    },
);

has_field full_markdown => (
    label       => 'Full Description',
    type        => 'Input::TextArea',
    filters     => [qw/ TrimEdges /],
    validators  => [qw/ Required  /],
    data        => sub {
        my ($field, $form) = @_;

        return $form->_markdown_field_data('full');
    },
);

has_field full_preview => (
    type        => 'Html',
    options     => {
        html => q{<div id="markdown-preview-full" class="markdown full markdown-preview"></div>},
    },
);

has_button submit => ();
has_button cancel => (style => 'light', skip_validation => 1);

sub _markdown_field_data {
    my ($self, $name) = @_;

    my %data = ('markdown-preview' => 'markdown-preview-' . $name);

    if ( $self->is_update ) {
        $data{'song-id'} = $self->song->id;
    }

    return \%data;
}

override posted => sub {
    my $self = shift;

    my $update_button = $self->find_button('submit');
    if ( $update_button->clicked ) {

        my $user = $self->c->stash->{auth_user};

        # Whitelist what we extract from the submitted form
        my $fields = $self->form_hash(qw/ title album artist image country_id released_at summary_markdown full_markdown max_resolution /);

        # Create or update?
        if ( $self->is_update ) {
            # Update
            $user->admin_edit_song($self->song, $fields);
            $self->action('updated');
        }
        else {
            # Create
            $user->admin_create_song($fields);
            $self->action('created');
        }
    }

    return 1;
};

# Prepopulate GET form from the song object if it's an update
sub BUILD {
    my $self = shift;

    if ( $self->is_update ) {
     	$self->data_object($self->song);
    }
}

__PACKAGE__->meta->make_immutable;
1;
