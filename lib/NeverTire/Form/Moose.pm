package NeverTire::Form::Moose;
use Moose;
use namespace::autoclean;

use NeverTire::Form::Field;
use NeverTire::Form::Button;

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
        for				=> $options{for_class},
        class_metaroles => {
            class => ['NeverTire::Form::Meta::Form'],
        },
    );
}

sub has_field {
    my ($meta, $name, %options) = @_;

    my $field = NeverTire::Form::Field->new(
        name    => $name,
        %options,
    );

    # Set the right render method for the type
    Moose::Util::apply_all_roles($field, 'NeverTire::Form::Render::' . $options{type});
    
    $meta->add_field($field);
    return $field;
}

sub has_button {
    my ($meta, $name, %options) = @_;

    my $button = NeverTire::Form::Button->new(
        name    => $name,
        %options,
    );

    $meta->add_button($button);
    return $button;
}

1;
