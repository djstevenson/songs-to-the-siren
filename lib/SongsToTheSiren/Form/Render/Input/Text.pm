package SongsToTheSiren::Form::Render::Input::Text;
use utf8;
use Moose::Role;
use namespace::autoclean;

with 'SongsToTheSiren::Form::Render::Input::Generic';

sub render {
    my ($self, $form) = @_;
    return $self->input_render($form, 'text');
}

1;
