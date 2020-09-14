package SongsToTheSiren::Form::Render::Select;
use utf8;
use Moose::Role;
use namespace::autoclean;

with 'SongsToTheSiren::Form::Render::Input::Generic';

use Carp;

# TODO POD
# TODO Unit tests
sub render {
    my ($self, $form) = @_;

    my $buttons = $self->get_selections($form) or croak 'What no buttons?';

    my $name  = $self->name;
    my $id    = $self->_name_to_id($form, $name);
    my $label = $self->label;

    my $s;

    my $selected = $self->has_value ? $self->value : $buttons->[0]->id;
    $selected ||= 0;

    $s = qq{<div class="form-group"><label for="${id}">$label</label><select class="form-control" name="${name}" id="${id}">};
    foreach my $button ( @{ $buttons } ) {
        my $value    = $button->{value};
        my $sel_attr = defined($value) && "$selected" eq "$value" ? 'selected="selected"' : 0;
        $label    = $button->{text} // $value;

        $s .= qq{ <option value="${value}" ${sel_attr}>${label}</option> };
    }

    my $error_id = 'error-' . $id;
    my $error    = qq{<span id="${error_id}" class=""></span>};
    $s .= qq{</select>${error}</div>};

    return $s;
}

1;
