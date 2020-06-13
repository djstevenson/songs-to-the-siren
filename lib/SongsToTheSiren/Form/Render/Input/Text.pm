package SongsToTheSiren::Form::Render::Input::Text;
use Moose::Role;
use namespace::autoclean;

with 'SongsToTheSiren::Form::Render::Input::Generic';

sub render {
    my ($self, $form) = @_;
    return $self->_input_render($form, 'text');
}

1;
