package SongsToTheSiren::Form::Render::Checkbox;
use utf8;
use Moose::Role;
use namespace::autoclean;

use Carp;

sub render {
    my $self = shift;

    croak "Checkbox not yet implemented";

    # my $name = $self->name;
    # my $id = $form->id . '_' . $name;
    # my $value = $form->escaped_value_for($name);
    # my $checked = $value ? 'checked="checked"' : '';
    # my $label = $self->label;
    #
    # my $s;
    #
    # my $err = $error ? ' error' : '';
    # $s .= qq(<div class="control-group${err}">);
    # $s .= qq(<label class="control-label" for="$name">${label}</label>);
    # $s .= q(<div class="controls">);
    #
    # my $help = '';
    # if ($self->has_help){
    #     $help = $self->help;
    # }
    # $s .= q(<label class="checkbox">);
    # $s .= qq(<input id="${id}" name="${name}" class="checkbox" type="checkbox" ${checked} /> $help);
    # $s .= q(</label>);
    #
    # $s .= $error ? qq( <span class="help-inline">${error}</span>) : '';
    # $s .= q(</div>);  # controls
    # $s .= q(</label>);
    # $s .= q(</div>);  # control-groups
    # return $s;
}

1;

1;
