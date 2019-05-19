package NeverTire::Form::Role;
use Moose::Role;

requires 'posted';
requires 'extra_validation';

no Moose::Role;
1;
