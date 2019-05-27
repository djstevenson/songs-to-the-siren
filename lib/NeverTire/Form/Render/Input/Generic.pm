package NeverTire::Form::Render::Input::Generic;
use Moose::Role;
use namespace::autoclean;

sub _name_to_id {
    my ($self, $form, $name) = @_;

    return $form->id . '-' . $name;
}

sub _input_render {
    my ($self, $form, $type) = @_;

    my $name        = $self->name;
    my $id          = $self->_name_to_id($form, $name);
    my $label       = $self->label;
    my $placeholder = $self->placeholder;

    my $value = '';
    my $error_class = '';
    my $text = '';
    my $error_id = 'error-' . $id;
    if ($self->has_error) {
        $text = $self->error;
        $error_class = ' is-invalid';
    }
    my $error = qq{<span id="${error_id}" class="" ${error_class}">${text}</span>};

    if ($self->has_value && $type ne 'password') {
        $value = $self->value;
    }

    my $autofocus = $self->autofocus ? 'autofocus="autofocus"' : '';
    return qq{
        <div class="form-group">
            <label for="${id}">${label}</label>
            <input type="${type}" id="${id}" name="${name}" $autofocus class="form-control${error_class}" placeholder="${placeholder}" value="${value}"/>
            ${error}
        </div>
    };
}

1;

