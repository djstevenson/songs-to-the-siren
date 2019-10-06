package NeverTire::Form::Render::Select;
use Moose::Role;
use namespace::autoclean;

with 'NeverTire::Form::Render::Input::Generic';

# TODO POD
# TODO Unit tests
sub render {
    my ($self, $form) = @_;

    my $buttons = $self->_get_selections($form) or die 'What no buttons?';

    my $name  = $self->name;
    my $id    = $self->_name_to_id($form, $name);
    my $label = $self->label;

    my $s;

    my $selected = $self->has_value ? $self->value : $buttons->[0]->id;

    $s = qq{<div class="form-group"><label for="${id}">$label</label><select class="form-control" name="${name}" id="${id}">};
    foreach my $button (@$buttons) {
        my $value    = $button->{value};
        my $selected = $selected == $value ? 'selected="selected"' : '';
        my $label    = $button->{text} // $value;

        $s .= qq{ <option value="${value}" ${selected}>${label}</option> };
    }

    my $error_id    = 'error-' . $id;
    my $error = qq{<span id="${error_id}" class=""></span>};
    $s .= qq{</select>${error}</div>};

    return $s;
}

1;
