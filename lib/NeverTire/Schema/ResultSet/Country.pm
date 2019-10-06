package NeverTire::Schema::ResultSet::Country;
use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';

# POD docs at end of this source file

use Carp qw/ croak /;

use DateTime;

sub name_order {
    my $self = shift;

    return $self->search(undef, {
        order_by => { -asc => 'name' }
    });
}

sub as_select_options {
    my $self = shift;

    my $rs = $self->name_order;

    return [
        map { { value => $_->id, text => $_->name } } $rs->all
    ];
}

__PACKAGE__->meta->make_immutable;
1;

=pod

=head1 NAME

NeverTire::Schema::ResultSet::Country : ResultSet subclass for countries

=head1 SYNOPSIS

    my $rs = $schema->resultset('Country');
    $rs->name_order-> ...;

=head1 DESCRIPTION

ResultSet methods for countries

=head1 METHODS

=over

=item name_order

Order by name ascending.

=back

=head1 AUTHOR

David Stevenson david@ytfc.com

=cut

