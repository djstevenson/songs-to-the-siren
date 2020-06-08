package SongsToTheSiren::Form::Render::RadioButtonGroup;
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
        my $checked  = $button->{checked} ? 'checked' : '';
        my $label    = $button->{text} // '';

        $s .= qq{
            <div class="form-check-inline">
                <label class="form-check-label">
                    <input type="radio" class="form-check-input" ${checked} value="${value}" name="${name}">${label}
                </label>
            </div>
        };
    }

    # Wrap in a fieldset for styling?
    return $s;
}

1;
