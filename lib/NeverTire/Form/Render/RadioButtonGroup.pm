package NeverTire::Form::Render::RadioButtonGroup;
use Moose::Role;
use namespace::autoclean;

# TODO POD
# TODO Unit tests
sub render {
    my ($self, $form) = @_;

    my $name    = $self->name;
    my $buttons = $self->_get_selections($form) or die 'What no buttons?';

    my $s;

    foreach my $button (@$buttons) {
        my $value    = $button->{value};
        my $checked  = $button->{checked} ? 'checked="checked"' : '';
        my $label    = $button->{text} // '';

        # TODO Use CSS rather than a BR...
        $s .= qq{ <label><input type="radio" value="${value}" name="${name}" ${checked}>${label}</label><br /> };
    }

    # Wrap in a fieldset for styling?
    return $s;
}

1;
