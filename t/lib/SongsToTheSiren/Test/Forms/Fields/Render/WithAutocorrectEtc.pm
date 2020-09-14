package SongsToTheSiren::Test::Forms::Fields::Render::WithAutocorrectEtc;
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
            field_args      => {
                name           => 'your-name',
                autocomplete   => 'off',
                autocorrect    => 'off',
                autocapitalize => 'none',
                spellcheck     => 'false',
            },
            field_type      => 'input',
            exp_label_attrs => {for => 'test-form-your-name'},
            exp_label       => 'Your name',
            exp_input_attrs => {
                type => 'text',
                name => 'your-name',
                class => 'form-control',
                value => '',
                autocomplete => 'off',
                autocorrect => 'off',
                autocapitalize => 'none',
                spellcheck => 'false',
                id => 'test-form-your-name',
            },
        });
    };

    subtest 'Input::TextArea' => sub {
        $self->_run_test('Input::TextArea', {
            field_args      => {
                name           => 'your-name',
                autocorrect    => 'off',
                autocapitalize => 'on',
                spellcheck     => 'true',
            },
            field_type      => 'textarea',
            exp_label_attrs => {for => 'test-form-your-name'},
            exp_label       => 'Your name',
            exp_input_attrs => {
                name => 'your-name',
                class => 'form-control',
                autocorrect => 'off',
                autocapitalize => 'on',
                spellcheck => 'true',
                id => 'test-form-your-name',
                rows => 6,
            },
        });
    };

    # Autocomplete can be set to values other than off,
    # e.g. new-password for sign-up form
    subtest 'Input::Password new password' => sub {
        $self->_run_test('Input::Password', {
            field_args      => {
                name           => 'your-pw',
                autocomplete   => 'new-password',
                autocorrect    => 'off',
                autocapitalize => 'none',
                spellcheck     => 'false',
            },
            field_type      => 'input',
            exp_label_attrs => {for => 'test-form-your-pw'},
            exp_label       => 'Your pw',
            exp_input_attrs => {
                type => 'password',
                name => 'your-pw',
                class => 'form-control',
                value => '',
                autocomplete => 'new-password',
                autocorrect => 'off',
                autocapitalize => 'none',
                spellcheck => 'false',
                id => 'test-form-your-pw',
            },
        });
    };
    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
