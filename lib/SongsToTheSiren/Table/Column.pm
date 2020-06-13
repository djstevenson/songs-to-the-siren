package SongsToTheSiren::Table::Column;
use Moose;
use namespace::autoclean;

with 'MooseX::Traits';

use SongsToTheSiren::Util::Date qw/ format_date /;
use HTML::Entities qw/ encode_entities /;
use URI::Escape;
use utf8;

# Name. By default, used as the DB field.
has name => (is => 'ro', isa => 'Str', required => 1,);

# If DB column is different to column name
has column => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub {
        return shift->name;
    },
);

# Table column header text. Defaults to
# ucfirst($name)
has header => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub {
        my $s = shift->name;
        $s =~ s/_/ /g;
        return ucfirst $s;
    },
);

has hidden => (is => 'ro', isa => 'Bool', default => 0,);

# Optional CSS for cells in this column
has cell_class => (is => 'ro', isa => 'Str', predicate => 'has_cell_class',);

# If you need to override the default content.
# Default is HTML-escaped value from DB field.
# TODO Document how this is called.
has content => (is => 'ro', isa => 'CodeRef', predicate => 'has_content',);

# If present, wraps the default content in a <a> link
# with this as the URL
has link => (is => 'ro', isa => 'CodeRef', predicate => 'has_link',);

# Set this if we are to format the column as a timestamp.
# The cell value must be a DateTime object
has timestamp => (is => 'ro', isa => 'Bool', default => 0,);

# Unicode characters for sort triangles, with any necessary css
has _active_arrow_down => (
    is      => 'ro',
    isa     => 'Str',
    default => '<span class="sort-arrow sort-arrow-down sort-arrow-down-active">▼</span>',
);

has _active_arrow_up =>
    (is => 'ro', isa => 'Str', default => '<span class="sort-arrow sort-arrow-up sort-arrow-up-active">▲</span>',);

has _inactive_arrow_down => (
    is      => 'ro',
    isa     => 'Str',
    default => '<span class="sort-arrow sort-arrow-down sort-arrow-down-inactive">▽</span>',
);

has _inactive_arrow_up =>
    (is => 'ro', isa => 'Str', default => '<span class="sort-arrow sort-arrow-up sort-arrow-up-inactive">△</span>',);

sub render_header_cell {
    my ($self, $table) = @_;

    return '' if $self->hidden;

    my $s = encode_entities($self->header);
    return qq{<th scope="col">$s</th>};
}

sub render_body_cell {
    my ($self, $table, $row) = @_;

    return '' if $self->hidden;

    my $s;
    if ($self->has_content) {
        $s = $self->content->($self, $table, $row);
    }
    else {
        my $col_name = $self->column;
        if ($row->can($col_name)) {
            $s = encode_entities($row->$col_name());
        }
        else {
            $s = encode_entities($row->get_column($col_name));
        }

        if ($self->timestamp) {
            $s = $s ? encode_entities(format_date($s)) : '-';
        }
        elsif ($self->has_link) {
            my $url = $self->link->($self, $table, $row);
            $s = qq{<a href="$url">$s</a>};
        }
    }

    my $class = $self->has_cell_class ? 'class="' . $self->cell_class . '"' : '';

    $s //= '';

    return qq{<td $class>$s</td>};
}

__PACKAGE__->meta->make_immutable;
1;
