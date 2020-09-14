package SongsToTheSiren::Test::Forms::Fields::Render::WithAutofocus;
use utf8;
use Moose;
use namespace::autoclean;

use Test::More;
use Test::Exception;

extends 'SongsToTheSiren::Test::Forms::Fields::Render::Base';
with 'SongsToTheSiren::Test::Role';

has '+user_base' => (default => 'form_field_render3');

sub run {
    my $self = shift;

    subtest 'Input::Text' => sub {
        $self->_run_test('Input::Text', {
            field_args      => {name => 'your-name', autofocus => 1},
            field_type      => 'input',
            exp_label_attrs => {for => 'test-form-your-name'},
            exp_label       => 'Your name',
            exp_input_attrs => {
                type => 'text',
                name => 'your-name',
                class => 'form-control',
                value => '',
                autofocus => undef,
                id => 'test-form-your-name',
            },
        });
    };

    subtest 'Input::TextArea' => sub {
        $self->_run_test('Input::TextArea', {
            field_args      => {name => 'your-name', autofocus => 1},
            field_type      => 'textarea',
            exp_label_attrs => {for => 'test-form-your-name'},
            exp_label       => 'Your name',
            exp_input_attrs => {
                name => 'your-name',
                class => 'form-control',
                autofocus => undef,
                id => 'test-form-your-name',
                rows => 6,
            },
        });
    };

    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
