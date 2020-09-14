package SongsToTheSiren::Schema::ResultSet::Email;
use utf8;
use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';

# POD docs at end of this source file
use Carp;

sub latest_email {
    my ($self, $type, $address) = @_;

    $self->assert_test_db;

    return $self->search(
        {template_name => $type, email_to => $address,},
        {
            rows     => 1,
            order_by => {-desc => 'id'},    # Most recent
        }
    )->single;
}

# TODO Create a common base class for resultsets and
# move this there
sub assert_test_db {
    my $self = shift;

    my $schema = $self->result_source->schema;
    my $dbh    = $schema->storage->dbh;
    my ($k, $name) = split(/=/, $dbh->{Name});
    croak unless $name eq 'songstothesiren_test';

    return;
}

__PACKAGE__->meta->make_immutable;
1;


=encoding utf8

=head1 NAME

Forum::Schema::Resultset::Email : ResultSet subclass for emails

=head1 SYNOPSIS

 my $rs = $schema->resultset('Email');

=head1 DESCRIPTION

ResultSet methods for Emails

=head1 METHODS

=over

=item latest_email

 $email->latest_email($type, $address)

e.g. $email->latest_email('registration', 'xxx@yyy.com');

Finds and returns the latest email of the given 'type'
(matching this against the template_name in the DB) for 
the given email address.

Returns an Email result object, or undef if none found.

=back

=head1 AUTHOR

David Stevenson david@ytfc.com

=cut

