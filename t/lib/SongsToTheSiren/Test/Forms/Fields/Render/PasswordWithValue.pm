package SongsToTheSiren::Test::Forms::Fields::Render::PasswordWithValue;
use utf8;
use Moose;
use namespace::autoclean;

use Test::More;
use Test::Exception;

extends 'SongsToTheSiren::Test::Forms::Fields::Render::Base';
with 'SongsToTheSiren::Test::Role';

has '+user_base' => (default => 'form_field_render6');

sub run {
    my $self = shift;

    $self->_run_test('Input::Password', {
        field_args      => {name => 'password', value => 'xyzzy'},
        field_type      => 'input',
        exp_label_attrs => {for => 'test-form-password'},
        exp_label       => 'Password',
        exp_input_attrs => {
            type => 'password',
            name => 'password',
            class => 'form-control',
            value => '',
			id => 'test-form-password',
        },
    });

    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
