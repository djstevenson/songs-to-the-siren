package SongsToTheSiren::Form::Render::Input::Generic;
use Moose::Role;
use namespace::autoclean;

sub _name_to_id {
    my ($self, $form, $name) = @_;

    my $id = $form->id . q{-} . $name;
    $id =~ s/_/-/g;
    return $id;
}

sub input_render {
    my ($self, $form, $type) = @_;

    my $name  = $self->name;
    my $id    = $self->_name_to_id($form, $name);
    my $label = $self->label;

    my $value       = q{};
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

    if ($self->has_value && $type ne 'password') {
        $value = $self->value;
    }

    my $data = $self->render_data($form);

    # TODO If the form has errors, consider patching autofocus to go to the first error field?
    my $autofocus_etc = $self->_get_auto_attributes;
    return <<"FORM_GROUP";
        <div class="form-group">
            <label for="${id}">${label}</label>
            <input type="${type}" id="${id}" ${data} name="${name}" ${autofocus_etc} class="${input_class}" value="${value}"/>
            ${error}
        </div>
FORM_GROUP
}

# TODO This is also in the textarea renderer.
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
    $attrs{inputmode}      = $self->inputmode      if $self->has_inputmode;

    return join(q{ }, map { defined($attrs{$_}) ? $_ . q{="} . $attrs{$_} . q{"} : $_ } keys %attrs);
}

no Moose::Role;
1;

