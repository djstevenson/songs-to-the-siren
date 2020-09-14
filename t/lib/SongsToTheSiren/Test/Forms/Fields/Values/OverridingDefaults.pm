package SongsToTheSiren::Test::Forms::Fields::Values::OverridingDefaults;
use utf8;
use Moose;
use namespace::autoclean;

use Test::More;
use Test::Exception;

extends 'SongsToTheSiren::Test::Base';
with 'SongsToTheSiren::Test::Role';

has '+user_base' => (default => 'form_field_values2');

use SongsToTheSiren::Form::Field;

sub run {
    my $field = SongsToTheSiren::Form::Field->new({
       name => 'your-name',
       type => 'Input::Text',
       label => 'My label',
    });

    is($field->label, 'My label', 'Overrides label ok');

    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
