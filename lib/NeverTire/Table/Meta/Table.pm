package NeverTire::Table::Meta::Table;

use Moose::Role;

has table_columns => (
    traits      => ['Array'],
    is			=> 'rw',
    isa			=> 'ArrayRef[NeverTire::Table::Column]',
    default		=> sub{ [] },
    handles     => {
        add_column => 'push',
    },
);


no Moose::Role;

1;
