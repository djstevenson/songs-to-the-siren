package NeverTire::Schema::Base::Result;
use base 'DBIx::Class::Core';

# Asserts that we are using the test DB, throwing an
# exception if not. Used in code that exists to support
# tests but that shouldn't be available in production

sub _assert_test_db {
    my $self = shift;

    my $dbh = $self->result_source->schema->storage->dbh;
    my ($k, $name) = split(/=/, $dbh->{Name});
    die unless $name eq 'never_tire_test';
}

1;
