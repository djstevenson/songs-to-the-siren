package SongsToTheSiren::Table::Content::List;
use Moose;
use namespace::autoclean;

use SongsToTheSiren::Table::Moose;
extends 'SongsToTheSiren::Table::Base';

use DateTime;

sub _build_resultset {
    my $self = shift;

    return $self->c->schema->resultset('Content')->search(undef, {order_by => 'name'});    # Resultset helper
}

has_column name => (
    link => sub {
        my ($col, $table, $row) = @_;

        return $table->c->url_for('view_content', name => $row->name);
    },
);

has_column title => ();

has_column updated_at => ();

has_column edit => (
    content => sub {
        my ($col, $table, $row) = @_;

        my $url = $table->c->url_for('admin_edit_content', name => $row->name);
        return qq{
            <a href="${url}">Edit</a>
        };
    },

);

has_column delete => (
    content => sub {
        my ($col, $table, $row) = @_;

        my $url = $table->c->url_for('admin_delete_content', name => $row->name);
        return qq{
            <a href="${url}">Delete</a>
        };
    },

);

has '+empty_text' => (default => 'No content yet defined');

__PACKAGE__->meta->make_immutable;
1;
