package SongsToTheSiren::Form::Role;
use utf8;
use Moose::Role;

requires 'posted';
requires 'extra_validation';

no Moose::Role;
1;
