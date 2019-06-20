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

# sub process {
#     my ($self, $schema, $value) = @_;

#     my $filtered_value = $value // '';
#     my $filters = NeverTire::Form::Utils::load_form_objects(
#         $self->filters,
#         'NeverTire::Form::Field::Filter',
#         {schema => $schema},
#     );

#     foreach my $filter (@$filters) {
#         $filtered_value = $filter->filter($filtered_value);
#     }
#     $self->value($filtered_value);

#     # TODO Instantiate these once, not on every form POST
#     #      e.g. get them via a factory, they can be cached
#     #           so can actual forms if we init them right...
#     my $validators = NeverTire::Form::Utils::load_form_objects(
#         $self->validators,
#         'NeverTire::Form::Field::Validator',
#         {schema => $schema},
#     );
#     $self->clear_error;
#     foreach my $validator (@$validators) {
#         my $error_value = $validator->validate($filtered_value);
#         if ($error_value){
#             $self->error($error_value);
#             last;
#         }
#     }
# }

__PACKAGE__->meta->make_immutable;
1;
