package NeverTire::Form::Field;
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

        $label =~ s/_/ /;
        $label =~ s/\-/ /;

        return $label;
    },
);

has type => (
    is			=> 'ro',
    isa			=> 'Str',
    required	=> 1,
);

has validators => (
    is          => 'ro',
    isa         => 'ArrayRef',
    default     => sub{ return []; },
);

has filters => (
    is          => 'ro',
    isa         => 'ArrayRef',
    default     => sub{ return []; },
);

has autofocus => (
    is			=> 'ro',
    isa			=> 'Bool',
    required    => 1,
    default     => 0,
);

has placeholder => (
    is          => 'ro',
    isa         => 'Str',
    lazy        => 1,
    default     => sub { return shift->label; },
);

# Hashref, or coderef that returns hashref.
# Coderef is called with ($self, $form)
# $self being the field object
has options => (
    is          => 'ro',
    isa         => 'HashRef|CodeRef',
    default     => sub { return {}; },
);

# For radio buttons (and probs can re-use for select menus)
has selections => (
    is          => 'ro',
    isa         => 'ArrayRef',  # TODO also accept coderef
    default     => sub { return []; },
);

has value => (
    is          => 'rw',
    isa         => 'Str',
    clearer     => 'clear_value',
    predicate   => 'has_value',
);

has error => (
    is          => 'rw',
    isa         => 'Str',
    clearer     => 'clear_error',
    predicate   => 'has_error',
);

sub process {
    my ($self, $schema, $value) = @_;

    my $filtered_value = $value // '';
    my $filters = NeverTire::Form::Utils::load_form_objects(
        $self->filters,
        'NeverTire::Form::Field::Filter',
        {schema => $schema},
    );

    foreach my $filter (@$filters) {
        $filtered_value = $filter->filter($filtered_value);
    }
    $self->value($filtered_value);

    # TODO Instantiate these once, not on every form POST
    #      e.g. get them via a factory, they can be cached
    #           so can actual forms if we init them right...
    my $validators = NeverTire::Form::Utils::load_form_objects(
        $self->validators,
        'NeverTire::Form::Field::Validator',
        {schema => $schema},
    );
    $self->clear_error;
    foreach my $validator (@$validators) {
        my $error_value = $validator->validate($filtered_value);
        if ($error_value){
            $self->error($error_value);
            last;
        }
    }
}

# TODO POD
# Assumes that we are in a GET operation, i.e. we need to
# make an initial value for a field
sub set_initial_value {
	my ($self, $form) = @_;

	my $v = $self->_get_initial_value($form);

	$self->value($v);
}

sub _get_initial_value {
	my ($self, $form) = @_;

    return '' if $self->type eq 'Html';

	# Get from initial_value option if we have one.
	# Else get from data_object if we have one.
	# Else blank.

    my $options = $self->_get_options($form);
	return $options->{initial_value}
		if exists $options->{initial_value};

	return $form->data_object->get_column($self->name)
		if $form->has_data_object;

	return '';
}

sub _get_options {
    my ($self, $form) = @_;

    my $options = $self->options;
    if (ref($options) eq 'CODE') {
        $options = $options->($self, $form);
    }

    die 'Invalid options' unless ref($options) eq 'HASH';
    return $options;
}

__PACKAGE__->meta->make_immutable;
1;
