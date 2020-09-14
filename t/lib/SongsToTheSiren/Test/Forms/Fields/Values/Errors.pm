package SongsToTheSiren::Test::Forms::Fields::Values::Errors;
use utf8;
use Moose;
use namespace::autoclean;

use Test::More;
use Test::Exception;

extends 'SongsToTheSiren::Test::Base';
with 'SongsToTheSiren::Test::Role';

has '+user_base' => (default => 'form_field_values4');

use SongsToTheSiren::Form::Field;

sub run {
    my $field = SongsToTheSiren::Form::Field->new({
       name => 'your-name',
       type => 'Input::Text',
    });

    my $msg = 'This is a test error';
    $field->error($msg);
    ok($field->has_error, 'Field has an error after we set one');
    is($field->error, $msg, 'Field has correct error');

    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
