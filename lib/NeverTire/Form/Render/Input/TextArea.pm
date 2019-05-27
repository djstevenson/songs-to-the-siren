package NeverTire::Form::Render::Input::TextArea;
use Moose::Role;
use namespace::autoclean;

with 'NeverTire::Form::Render::Input::Generic';

sub render {
    my ($self, $form) = @_;

    my $name        = $self->name;
    my $id          = $self->_name_to_id($form, $name);
    my $label       = $self->label;
    my $placeholder = $self->placeholder;

    my $error = '';
	my $value = $self->has_value ? $self->value : '';
    my $error_class = '';
    if ($self->has_error) {
        my $text = $self->error;
        $error = qq{<div class="invalid-feedback">${text}</div>};
        $error_class = ' is-invalid';
    }

    my $autofocus = $self->autofocus ? 'autofocus="autofocus"' : '';

    my $options = $self->_get_options;
	my $rows = exists $options->{rows} ? $options->{rows} : 6;

    return qq{
		<div class="form-group">
			<label for="${id}">${label}</label>
			<textarea id="${id}" name="${name}" $autofocus class="form-control${error_class}" rows="${rows}" placeholder="${placeholder}">${value}</textarea>
			${error}
		</div>
	};
}

1;
