package SongsToTheSiren::Form::Field::Filter::Role;
use Moose::Role;

# my $filtered_field_value = $filter->filter($this_value);
requires 'filter';

no Moose::Role;
1;
