package SongsToTheSiren::Test::Forms::Fields::Render::Data;
use utf8;
use Moose;
use namespace::autoclean;

use Test::More;
use Test::Exception;

extends 'SongsToTheSiren::Test::Forms::Fields::Render::Base';
with 'SongsToTheSiren::Test::Role';

has '+user_base' => (default => 'form_field_render11');

sub run {
    my $self = shift;

    # Data as a fixed hash
    # Should generate:
    # <tag data-abc="1" data-def="blah" data-ghi>
    subtest 'Text input, data as hashref' => sub {
        $self->_run_test('Input::Text', {
            field_args      => {name => 'your-name', data => { abc => 1, def => 'blah', ghi => undef }},
            field_type      => 'input',
            exp_label_attrs => {for => 'test-form-your-name'},
            exp_label       => 'Your name',
            exp_input_attrs => {
                type => 'text',
                name => 'your-name',
                class => 'form-control',
                value => '',
                'data-abc' => '1',
                'data-def' => 'blah',
                'data-ghi' => undef,
                id => 'test-form-your-name',
            },
        });
    };

    # Data as a coderef.
    # Should generate:
    # <tag data-abc="2" data-def="blah" data-ghi>
    subtest 'Text input, data as coderef' => sub {
        $self->_run_test('Input::Text', {
            field_args      => {
                name => 'your-name',
                data => sub {
                    return { abc => 2, def => 'blah', ghi => undef };
                },
            },
            field_type      => 'input',
            exp_label_attrs => {for => 'test-form-your-name'},
            exp_label       => 'Your name',
            exp_input_attrs => {
                type => 'text',
                name => 'your-name',
                class => 'form-control',
                value => '',
                'data-abc' => '2',
                'data-def' => 'blah',
                'data-ghi' => undef,
                id => 'test-form-your-name',
            },
        });
    };

    # Data as a fixed hash
    # Should generate:
    # <tag data-abc="1" data-def="blah" data-ghi>
    subtest 'Textarea, data as hashref' => sub {
        $self->_run_test('Input::TextArea', {
            field_args      => {name => 'your-name', data => { abc => 3, def => 'blah', ghi => undef }},
            field_type      => 'textarea',
            exp_label_attrs => {for => 'test-form-your-name'},
            exp_label       => 'Your name',
            exp_input_attrs => {
                name => 'your-name',
                class => 'form-control',
                'data-abc' => '3',
                'data-def' => 'blah',
                'data-ghi' => undef,
                id => 'test-form-your-name',
                rows => 6,
            },
        });
    };

    # Data as a coderef.
    # Should generate:
    # <tag data-abc="2" data-def="blah" data-ghi>
    subtest 'Textarea, data as coderef' => sub {
        $self->_run_test('Input::TextArea', {
            field_args      => {
                name => 'your-name',
                data => sub {
                    return { abc => 4, def => 'blah', ghi => undef };
                },
            },
            field_type      => 'textarea',
            exp_label_attrs => {for => 'test-form-your-name'},
            exp_label       => 'Your name',
            exp_input_attrs => {
                name => 'your-name',
                class => 'form-control',
                'data-abc' => '4',
                'data-def' => 'blah',
                'data-ghi' => undef,
                id => 'test-form-your-name',
                rows => 6,
            },
        });
    };

    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
