package SongsToTheSiren::Test::Forms::Fields::Render::TextArea;
use utf8;
use Moose;
use namespace::autoclean;

extends 'SongsToTheSiren::Test::Forms::Fields::Render::Base';
with 'SongsToTheSiren::Test::Role';

use Test::More;

has '+user_base' => (default => 'form_field_render9');

sub run {
    my $self = shift;

    $self->_run_test('Input::TextArea', {
        field_args      => {name => 'your-name'},
        field_type      => 'textarea',
        exp_label_attrs => {for => 'test-form-your-name'},
        exp_label       => 'Your name',
        exp_input_attrs => {
            name => 'your-name',
            class => 'form-control',
			id => 'test-form-your-name',
            rows => 6,
        },
    });

    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
