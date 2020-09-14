package SongsToTheSiren::Test::Forms::Fields::Values::SomeDefaults;
use utf8;
use Moose;
use namespace::autoclean;

use Test::More;
use Test::Exception;

extends 'SongsToTheSiren::Test::Base';
with 'SongsToTheSiren::Test::Role';

has '+user_base' => (default => 'form_field_values1');

use SongsToTheSiren::Form::Field;

sub run {
    my $field = SongsToTheSiren::Form::Field->new({
       name => 'your-name',
       type => 'Input::Text',
    });

    is($field->label, 'Your name', 'Default label generated from name');
    ok(!$field->has_value, 'Has no value if we have not set one');
    ok(!$field->has_error, 'Has no error if we have not set one');

    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
