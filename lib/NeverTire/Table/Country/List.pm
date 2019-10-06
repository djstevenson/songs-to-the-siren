package NeverTire::Table::Country::List;
use Moose;
use namespace::autoclean;

use NeverTire::Table::Moose;
extends 'NeverTire::Table::Base';

use DateTime;

sub _build_resultset {
    my $self = shift;

    return $self->c->schema
        ->resultset('Country')
        ->name_order;
}

has_column name => ();

# TODO Need an option not to encode HTML entities so we can display the actual flags
has_column emoji => ();

has_column edit => (
    content => sub {
        my ($col, $table, $row) = @_;

        my $url = $table->c->url_for('admin_edit_country', country_id => $row->id);
        return qq{
            <a href="${url}">Edit</a>
        };
    },

);

has_column delete => (
    content => sub {
        my ($col, $table, $row) = @_;

        my $url = $table->c->url_for('admin_delete_country', country_id => $row->id);
        return qq{
            <a href="${url}">Delete</a>
        };
    },

);

has '+empty_text' => (default => 'No country codes yet defined');

__PACKAGE__->meta->make_immutable;
1;
