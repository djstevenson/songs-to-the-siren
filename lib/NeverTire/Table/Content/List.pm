package NeverTire::Table::Content::List;
use Moose;
use namespace::autoclean;

use NeverTire::Table::Moose;
extends 'NeverTire::Table::Base';

use DateTime;

sub _build_resultset {
    my $self = shift;

    # TODO Bug: Table code is dumb and forces sorting by one
    #      of the columns, so overrides by_pubdate. Fix this.
    return $self->c->schema
        ->resultset('Content');
}

has '+default_order_by' => (default => 'name');
has '+default_sort_dir' => (default => 'u');

has_column name => (
    link         => sub {
        my ($col, $table, $row) = @_;

        return $table->c->url_for('view_content', name => $row->name);
    },
);

has_column title => ();

has_column updated_at => ();

has_column edit => (
    content => sub {
        my ($col, $table, $row) = @_;

        my $url = $table->c->url_for('edit_content', name => $row->name);
        return qq{
            <a href="${url}">Edit</a>
        };
    },

);

has_column delete => (
    content => sub {
        my ($col, $table, $row) = @_;

        my $url = $table->c->url_for('delete_content', name => $row->name);
        return qq{
            <a href="${url}">Delete</a>
        };
    },

);

has '+empty_text' => (default => 'No content yet defined');

__PACKAGE__->meta->make_immutable;
1;
