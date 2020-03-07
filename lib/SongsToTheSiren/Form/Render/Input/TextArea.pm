package SongsToTheSiren::Form::Render::Input::TextArea;
use Moose::Role;
use namespace::autoclean;

with 'SongsToTheSiren::Form::Render::Input::Generic';

sub render {
    my ($self, $form) = @_;

    my $name        = $self->name;
    my $id          = $self->_name_to_id($form, $name);
    my $label       = $self->label;

	my $value       = $self->has_value ? $self->value : '';
    my $input_class = 'form-control';
    my $error_class = '';
    my $error_id    = 'error-' . $id;
    my $text        = '';
    if ($self->has_error) {
        $text = $self->error;
        $input_class .= ' is-invalid';
        $error_class = 'text-danger form-validation-error';
    }
    my $error = qq{<span id="${error_id}" class="${error_class}">${text}</span>};

    my $autofocus = $self->autofocus ? 'autofocus="autofocus"' : '';

    my $options = $self->_get_options;
	my $rows = exists $options->{rows} ? $options->{rows} : 6;

    my $data = $self->render_data;

    return qq{
		<div class="form-group">
			<label for="${id}">${label}</label>
			<textarea id="${id}" name="${name}" ${data} $autofocus class="${input_class}" rows="${rows}" >${value}</textarea>
			${error}
		</div>
	};
}

1;
