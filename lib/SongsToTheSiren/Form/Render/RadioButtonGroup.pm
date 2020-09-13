package SongsToTheSiren::Form::Render::RadioButtonGroup;
use Moose::Role;
use namespace::autoclean;

use Carp;

# TODO POD
# TODO Unit tests
sub render {
    my ($self, $form) = @_;

    my $name    = $self->name;
    my $buttons = $self->get_selections($form) or croak 'What no buttons?';

    my $s;

    foreach my $button ( @{ $buttons } ) {
        my $value   = $button->{value};
        my $checked = $button->{checked} ? 'checked' : q{};
        my $label   = $button->{text} // q{};

        $s .= <<"FORM_CHECK";
            <div class="form-check-inline">
                <label class="form-check-label">
                    <input type="radio" class="form-check-input" ${checked} value="${value}" name="${name}">${label}
                </label>
            </div>
FORM_CHECK
    }

    # Wrap in a fieldset for styling?
    return $s;
}

1;
