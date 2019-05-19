package NeverTire::Form::Render::Input::Email;
use Moose::Role;
use namespace::autoclean;

with 'NeverTire::Form::Render::Input::Generic';

sub render{
	my ($self, $form) = @_;
    return $self->_input_render($form, 'email');
}

1;
