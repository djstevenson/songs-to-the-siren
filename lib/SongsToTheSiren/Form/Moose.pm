package SongsToTheSiren::Form::Moose;
use Moose;
use namespace::autoclean;

use SongsToTheSiren::Form::Field;
use SongsToTheSiren::Form::Button;

use Moose::Exporter;
use Moose::Util::MetaRole;
use Moose::Util;

# Exporting sugar methods
Moose::Exporter->setup_import_methods(
    with_meta => [qw(
        has_field
        has_button
    )],
    also => 'Moose',
);

sub init_meta {
    my ($class, %options) = @_;

    # Setting up the moose stuff
    my $meta = Moose->init_meta(%options);

    # Apply the role to the caller class's metaclass object
    Moose::Util::MetaRole::apply_metaroles(
        for             => $options{for_class},
        class_metaroles => { class => ['SongsToTheSiren::Form::Meta::Form'] },
    );

    return;
}

sub has_field {
    my ($meta, $name, %options) = @_;

    my $field = SongsToTheSiren::Form::Field->new(name => $name, %options);

    # Set the right render method for the type
    Moose::Util::apply_all_roles($field, 'SongsToTheSiren::Form::Render::' . $options{type});

    $meta->add_field($field);
    return $field;
}

sub has_button {
    my ($meta, $name, %options) = @_;

    my $button = SongsToTheSiren::Form::Button->new(name => $name, %options);

    $meta->add_button($button);
    return $button;
}

1;
