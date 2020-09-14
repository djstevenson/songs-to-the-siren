package SongsToTheSiren::Form::Render::Input::Password;
use utf8;
use Moose::Role;
use namespace::autoclean;

with 'SongsToTheSiren::Form::Render::Input::Generic';

sub render {
    my ($self, $form) = @_;
    return $self->input_render($form, 'password');
}

1;
