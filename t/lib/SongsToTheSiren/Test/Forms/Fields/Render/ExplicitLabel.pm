package SongsToTheSiren::Test::Forms::Fields::Render::ExplicitLabel;
use utf8;
use Moose;
use namespace::autoclean;

use Test::More;
use Test::Exception;

extends 'SongsToTheSiren::Test::Forms::Fields::Render::Base';
with 'SongsToTheSiren::Test::Role';

has '+user_base' => (default => 'form_field_render8');

sub run {
    my $self = shift;

    $self->_run_test('Input::Text', {
        field_args      => {name => 'your-name', label => 'abc'},
        field_type      => 'input',
        exp_label_attrs => {for => 'test-form-your-name'},
        exp_label       => 'abc',
        exp_input_attrs => {
            type => 'text',
            name => 'your-name',
            class => 'form-control',
            value => '',
			id => 'test-form-your-name',
        },
    });

    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
