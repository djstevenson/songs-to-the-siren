package NeverTire::Test::Forms::Fields::Render::WithError;
use Moose;
use namespace::autoclean;

use Test::More;
use Test::Exception;

extends 'NeverTire::Test::Forms::Fields::Render::Base';
with 'NeverTire::Test::Role';

has '+user_base' => (default => 'form_field_render7');

sub run {
    my $self = shift;

    $self->_run_test('Input::Text', {
        field_args      => {name => 'your-name', error => 'Err xyzzy'},
        exp_label_attrs => {for => 'test-form-your-name'},
        exp_label       => 'Your name',
        exp_input_attrs => {
            type => 'text',
            name => 'your-name',
            class => 'pure-input-1 is-invalid',
            placeholder => 'Your name',
            value => '',
			id => 'test-form-your-name',
        },
    });

    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;