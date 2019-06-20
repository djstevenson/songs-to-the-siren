package NeverTire::Form::Base;
use namespace::autoclean;
use Moose;

use NeverTire::Form::Utils;

# This just defines filtering/validation for now.
# A more complete form package would include
# rendering too, but then if I do that I may
# as well use something like HTML::FormHandler...

has c => (
	is			=> 'ro',
	isa			=> 'Mojolicious::Controller',
    # weak_ref    => 1,
	required    => 1,
);

has id => (
	is          => 'ro',
	isa         => 'Str',
	required    => 1,
);

has form_fields => (
	is			=> 'ro',
	isa			=> 'ArrayRef[NeverTire::Form::Field]',
	required	=> 1,
	default		=>  sub{ ref(shift)->meta->form_fields },
);

has form_buttons => (
	is			=> 'ro',
	isa			=> 'ArrayRef[NeverTire::Form::Button]',
	required	=> 1,
	default		=>  sub{ ref(shift)->meta->form_buttons },
);

has data_object => (
	is			=> 'rw',
	isa			=> 'Object',
	predicate   => 'has_data_object',
);

# Populate fields from an object if we have one.
# Only on GET though, as on POST we'll populate from
# user input.
sub prepare {
	my $self = shift;

	return unless $self->c->req->method eq 'GET';

	foreach my $field (@{$self->form_fields}) {
		$field->set_initial_value($self);
	}
}

sub process {
	my $self = shift;

	$self->clear_errors;

	# Check it's a POST
	if ($self->c->req->method ne 'POST') {
		$self->clear_values;
		return;
	}

	# Get the list of params and filter and validate each one
	my $params = $self->c->req->params;
    my $schema = $self->c->schema;
	foreach my $field (@{$self->form_fields}) {
		my $name = $field->name;
		my $value = $params->param($name);
		$field->process($schema, $value);
	}

	my $selected_button = $params->param('submit-button');
	foreach my $button (@{$self->form_buttons}) {
		my $name = $button->name;
		$button->clicked(1) if $name eq $selected_button;
	}

	# Allow extra validation in a subclass
	$self->extra_validation;

	my $result = undef;
	if (!$self->has_error){
		$result = $self->posted;
	}

	return $result;
}

# Does a linear search of fields. The list is short, so this is good enough.
sub find_field {
	my ($self, $name) = @_;

	foreach my $field (@{$self->form_fields}) {
		return $field if $name eq $field->name;
	}

	return undef;
}

# Does a linear search of buttons. The list is short, so this is good enough.
sub find_button {
	my ($self, $name) = @_;

	foreach my $button (@{$self->form_buttons}) {
		return $button if $name eq $button->name;
	}

	return undef;
}

# TODO This is kinda O(n^2) but n is small, so it's good enough
sub form_hash {
	my ($self, @names) = @_;

	return {
		map {
			($_ => $self->find_field($_)->value)
		} @names
	};
}

sub has_error {
	my $self = shift;

	return scalar grep {$_->has_error} @{$self->form_fields};
}

sub clear_errors {
	my $self = shift;

	foreach my $field ( @{$self->form_fields} ) {
		$field->clear_error;
	}
}

sub clear_values {
	my $self = shift;

	foreach my $field ( @{$self->form_fields} ) {
		$field->clear_value;
	}
}

# Maybe implement your own version of this. Probably use 'after'
# TODO Document it
sub extra_validation{
}

# Override this.  Be careful with the return value.
# TODO Document it
sub posted{
	return 1;
}

sub render {
    my $self = shift;

	# Sets initial values from the data object if we have one
	$self->prepare;

    # Currently assume all submissions go the same URL that rendered the form
    # TODO "Required" indicators?
    #      Our forms are so small and hopefully obvious, that I think we can do
    #      away with any 'required' indications.
	#
	# NOTE: We choose to turn off client-side validation, cos it generally 
	#       sucks at the moment. A beneficial side-effect is that it's
	#       now easier to use Selenium to test server-side validations which
	#       we need to maintain/test regardless of front-end gubbins.
	my $fields  = $self->_fieldset($self->_render_fields);
	my $buttons = $self->_fieldset($self->_render_buttons);

    return qq{
        <div class="main-panel">
    		<form accept-charset="utf-8" method="POST" novalidate>
				$fields
				$buttons
    		</form>
        </div>
	};
}

sub _fieldset {
	my ($self, $s) = @_;

	return '' unless defined $s;

	return '<fieldset>' . $s . '</fieldset>';
}

sub _render_fields {
    my $self = shift;

    my $s;
	foreach my $field (@{$self->form_fields}) {
        $s .= $field->render($self);
    }

    return $s;
}

sub _render_buttons {
    my $self = shift;


	my $s;

	foreach my $button (@{$self->form_buttons}) {
		my $type  = $button->type;
		my $name  = $button->name;
		my $style = $button->style;
		my $label = $button->label;
		my $id    = $button->id;
        $s .= qq{<button name="submit-button" value="${name}" id="${id}" type="${type}" class="btn btn-${style}">${label}</button>};
    }

    return $s;
}

__PACKAGE__->meta->make_immutable;
1;
