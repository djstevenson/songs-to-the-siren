package NeverTire::Table::Moose;
use Moose;
use namespace::autoclean;

use NeverTire::Table::Column;

use Moose::Exporter;
use Moose::Util::MetaRole;
use Moose::Util;
use Class::Load qw/ load_class /;

# Exporting sugar methods
Moose::Exporter->setup_import_methods(
    with_meta => [qw(
        has_column
    )],
    also => 'Moose',
);

sub init_meta{
    my ($class, %options) = @_;

    # Setting up the moose stuff
    my $meta = Moose->init_meta(%options);

    # Apply the role to the caller class's metaclass object
    Moose::Util::MetaRole::apply_metaroles(
        for				=> $options{for_class},
        class_metaroles => {
            class => ['NeverTire::Table::Meta::Table'],
        },
    );
}

sub has_column{
    my ($meta, $name, %options) = @_;

    my $class_name = delete $options{column_class};
    if ($class_name) {
        $class_name = 'NeverTire::Table::Column::' . $class_name;
        load_class($class_name);
    }
    else {
        $class_name = 'NeverTire::Table::Column';
    }

    my $column = $class_name->new(
        name    => $name,
        %options,
    );

    $meta->add_column($column);
    return $column;
}

1;
