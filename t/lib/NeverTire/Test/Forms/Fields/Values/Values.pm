package NeverTire::Test::Forms::Fields::Values::Values;
use Moose;
use namespace::autoclean;

use Test::More;
use Test::Exception;

extends 'NeverTire::Test::Base';
with 'NeverTire::Test::Role';

has '+user_base' => (default => 'form_field_values3');

use NeverTire::Form::Field;

# TODO Also need tests for setting values via a data object to the form
#      In fact, need a whole load of form-level tests
sub run {
    my $field = NeverTire::Form::Field->new({
       name => 'your-name',
       type => 'Input::Text',
    });

    my $msg = 'This is a test value';
    $field->value($msg);
    ok($field->has_value, 'Field has an value after we set one');
    is($field->value, $msg, 'Field has correct value');

    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;