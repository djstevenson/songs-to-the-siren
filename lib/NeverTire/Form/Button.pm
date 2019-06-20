package NeverTire::Form::Button;
use Moose;
use namespace::autoclean;

has name => (
    is			=> 'ro',
    isa			=> 'Str',
    required	=> 1,
);

has label => (
    is			=> 'ro',
    isa			=> 'Str',
    lazy        => 1,
    default     => sub {
        my $self = shift;
        my $label = ucfirst($self->name);

        $label =~ s/[_\-]/ /g;

        return $label;
    },
);

has id => (
    is          => 'ro',
    isa         => 'Str',
    lazy        => 1,
    default     => sub {
        my $self = shift;
        my $label = ucfirst($self->name);

    	my $id = lc($label) . '-button';
	    $id =~ s/[_\s]+/-/g;

        return $id;
    },
);

# Bootstrap 4 name, like 'primary'. Lower case only.
# TODO Maybe make this an "enum"?
has style => (
    is			=> 'ro',
    isa			=> 'Str',
    required	=> 1,
    default     => 'primary',
);

# e.g. "submit"
has type => (
    is          => 'ro',
    isa         => 'Str',
    default     => 'submit',
);

has clicked => (
    is          => 'rw',
    isa         => 'Bool',
    default     => 0,
);

__PACKAGE__->meta->make_immutable;
1;
