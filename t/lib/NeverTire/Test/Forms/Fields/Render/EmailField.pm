package NeverTire::Test::Forms::Fields::Render::EmailField;
use Moose;
use namespace::autoclean;

use Test::More;
use Test::Exception;

extends 'NeverTire::Test::Forms::Fields::Render::Base';
with 'NeverTire::Test::Role';

has '+user_base' => (default => 'form_field_render4');

sub run {
    my $self = shift;

    $self->_run_test('Input::Email', {
        field_args      => {name => 'email', value => 'xyzzy@example.com'},
        exp_label_attrs => {for => 'test-form-email'},
        exp_label       => 'Email',
        exp_input_attrs => {
            type => 'email',
            name => 'email',
            class => 'form-control',
            placeholder => 'Email',
            value => 'xyzzy@example.com',
			id => 'test-form-email',
        },
    });

    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
