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
        ->search(undef, { order_by => 'name'});
}

has_column name => ();

# TODO Need an option not to encode HTML entities so we can display the actual flags
has_column emoji => ();

has_column edit => (
    content => sub {
        my ($col, $table, $row) = @_;

        my $url = $table->c->url_for('admin_edit_country', name => $row->name);
        return qq{
            <a href="${url}">Edit</a>
        };
    },

);

# has_column delete => (
#     content => sub {
#         my ($col, $table, $row) = @_;

#         my $url = $table->c->url_for('admin_delete_content', name => $row->name);
#         return qq{
#             <a href="${url}">Delete</a>
#         };
#     },

# );

has '+empty_text' => (default => 'No country codes yet defined');

__PACKAGE__->meta->make_immutable;
1;
