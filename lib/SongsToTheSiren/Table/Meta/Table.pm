package SongsToTheSiren::Table::Meta::Table;
use utf8;
use Moose::Role;

has table_columns => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'ArrayRef[SongsToTheSiren::Table::Column]',
    default => sub { [] },
    handles => {add_column => 'push',},
);


no Moose::Role;

1;
