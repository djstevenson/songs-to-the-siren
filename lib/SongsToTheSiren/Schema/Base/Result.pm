package SongsToTheSiren::Schema::Base::Result;
use utf8;
use base 'DBIx::Class::Core';

use strict;
use warnings;

use Carp;

# Asserts that we are using the test DB, throwing an
# exception if not. Used in code that exists to support
# tests but that shouldn't be available in production

sub assert_test_db {
    my $self = shift;

    my $schema = $self->result_source->schema;
    my $dbh    = $schema->storage->dbh;

    my ($k, $name) = split(/=/, $dbh->{Name});
    croak unless $name eq 'songstothesiren_test';

    return;
}

1;
