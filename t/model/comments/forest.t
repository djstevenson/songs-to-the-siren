#!/usr/bin/env perl
use strict;
use warnings;

##### START BOILERPLATE
use FindBin::libs;

use Test::More;

my $builder = Test::More->builder;
binmode $builder->output, ':encoding(utf8)';
binmode $builder->failure_output, ':encoding(utf8)';

use SongsToTheSiren::Test;
my $test = SongsToTheSiren::Test->new;

##### END BOILERPLATE

$test->run('Model::Comment::Forest');
