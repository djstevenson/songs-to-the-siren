package SongsToTheSiren::Test::Forms::Fields::Render::TextAreaWithError;
use Moose;
use namespace::autoclean;

extends 'SongsToTheSiren::Test::Forms::Fields::Render::Base';
with 'SongsToTheSiren::Test::Role';

use Test::More;

has '+user_base' => (default => 'form_field_render10');

sub run {
    my $self = shift;

    $self->_run_test('Input::TextArea', {
        field_args      => {name => 'your-name', error => 'Err xyzzy'},
        field_type      => 'textarea',
        exp_label_attrs => {for => 'test-form-your-name'},
        exp_label       => 'Your name',
        exp_input_attrs => {
            name => 'your-name',
            class => 'form-control is-invalid',
			id => 'test-form-your-name',
            rows => 6,
        },
    });

    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
