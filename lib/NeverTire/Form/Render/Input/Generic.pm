package NeverTire::Form::Render::Input::Generic;
use Moose::Role;
use namespace::autoclean;

sub _name_to_id {
    my ($self, $form, $name) = @_;

    my $id = $form->id . '-' . $name;
    $id =~ s/_/-/g;
    return $id;
}

sub _input_render {
    my ($self, $form, $type) = @_;

    my $name        = $self->name;
    my $id          = $self->_name_to_id($form, $name);
    my $label       = $self->label;
    my $placeholder = $self->placeholder;

    my $value       = '';
    my $input_class = 'form-control';
    my $error_class = '';
    my $error_id    = 'error-' . $id;
    my $text        = '';

    if ($self->has_error) {
        $text = $self->error;
        $input_class .= ' is-invalid';
        $error_class = 'text-danger';
    }
    my $error = qq{<span id="${error_id}" class="${error_class}">${text}</span>};

    if ($self->has_value && $type ne 'password') {
        $value = $self->value;
    }

    my $data = $self->render_data;

    # TODO If the form has errors, consider patching autofocus to go to the first error field?
    my $autofocus = $self->autofocus ? 'autofocus="autofocus"' : '';
    return qq{
        <div class="form-group">
            <label for="${id}">${label}</label>
            <input type="${type}" id="${id}" ${data} name="${name}" $autofocus class="${input_class}" placeholder="${placeholder}" value="${value}"/>
            ${error}
        </div>
    };
}

1;

