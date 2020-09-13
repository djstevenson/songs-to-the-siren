package SongsToTheSiren::Model::Comment::Node;
use Moose;
use namespace::autoclean;

# TODO POD

# Required constructor arg
has comment => (is => 'ro', isa => 'SongsToTheSiren::Schema::Result::Comment', required => 1);

has children => (
    traits   => ['Array'],
    is       => 'ro',
    isa      => 'ArrayRef[SongsToTheSiren::Model::Comment::Node]',
    lazy     => 1,
    init_arg => undef,
    default  => sub { return []; },
    handles  => {add_child => 'unshift',},
);

# Document this, walks a tree
# executing the coderef on the current
# node, then calls itself recursively on
# the children.  Returns the
# accumulated string.

sub evaluate {
    my ($self, $coderef) = @_;

    my $s = $coderef->($self);
    if (scalar @{$self->children}) {
        $s .= join(q{}, map { $coderef->($_) } @{ $self->children });
    }
    return $s;
}

__PACKAGE__->meta->make_immutable;
1;
