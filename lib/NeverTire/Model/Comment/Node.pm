package NeverTire::Model::Comment::Node;
use Moose;
use namespace::autoclean;

# TODO POD

# Required constructor arg
has comment => (
    is          => 'ro',
    isa         => 'NeverTire::Schema::Result::Comment',
    required    => 1,
);

has children => (
    traits      => ['Array'],
    is          => 'ro',
    isa         => 'ArrayRef[NeverTire::Model::Comment::Node]',
    lazy        => 1,
    init_arg    => undef,
    default     => sub{ return []; },
    handles     => {
        add_child => 'unshift',
    },
);

__PACKAGE__->meta->make_immutable;
1;
