package SongsToTheSiren::Form::Render::Input::TextArea;
use Moose::Role;
use namespace::autoclean;

with 'SongsToTheSiren::Form::Render::Input::Generic';

use Readonly;

Readonly my $DEFAULT_ROWS => 6;

sub render {
    my ($self, $form) = @_;

    my $name  = $self->name;
    my $id    = $self->_name_to_id($form, $name);
    my $label = $self->label;

    my $value       = $self->has_value ? $self->value : q{};
    my $input_class = 'form-control';
    my $error_class = q{};
    my $error_id    = 'error-' . $id;
    my $text        = q{};
    if ($self->has_error) {
        $text = $self->error;
        $input_class .= ' is-invalid';
        $error_class = 'text-danger form-validation-error';
    }
    my $error = qq{<span id="${error_id}" class="${error_class}">${text}</span>};

    my $autofocus_etc = $self->_get_auto_attributes;

    my $options = $self->_get_options;
    my $rows    = exists $options->{rows} ? $options->{rows} : $DEFAULT_ROWS;

    my $data = $self->render_data($form);

    # TODO Move to tt2 template file?
    return <<"END_FORM_GROUP";
		<div class="form-group">
			<label for="${id}">${label}</label>
			<textarea id="${id}" name="${name}" ${data} ${autofocus_etc} class="${input_class}" rows="${rows}" >${value}</textarea>
			${error}
		</div>
END_FORM_GROUP
}

# TODO This is also in the generic input renderer.
#      Do something about this duped code.

sub _get_auto_attributes {
    my ($self) = @_;

    my %attrs;

    # autofocus HTML5 is a boolean (present or not).
    # The others here take a value.
    $attrs{autofocus}      = undef                 if $self->autofocus;
    $attrs{autocomplete}   = $self->autocomplete   if $self->has_autocomplete;
    $attrs{autocorrect}    = $self->autocorrect    if $self->has_autocorrect;
    $attrs{autocapitalize} = $self->autocapitalize if $self->has_autocapitalize;
    $attrs{spellcheck}     = $self->spellcheck     if $self->has_spellcheck;

    # Not sure this makes sense for a textarea...
    $attrs{inputmode}      = $self->inputmode      if $self->has_inputmode;


    return join(q{ }, map { defined($attrs{$_}) ? $_ . q{="} . $attrs{$_} . q{"} : $_ } keys %attrs);
}

no Moose::Role;
1;


