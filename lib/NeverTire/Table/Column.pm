package NeverTire::Table::Column;
use Moose;
use namespace::autoclean;

with 'MooseX::Traits';

use NeverTire::Util::Date qw/ format_date /;
use HTML::Entities        qw/ encode_entities /;
use URI::Escape;
use utf8;

# Name. By default, used as the DB field.
has name => (
    is          => 'ro',
    isa         => 'Str',
    required    => 1,
);

# If DB column is different to column name
has column => (
    is          => 'ro',
    isa         => 'Str',
    lazy        => 1,
    default     => sub {
        return shift->name;
    },
);

# Table column header text. Defaults to
# ucfirst($name)
has header => (
    is          => 'ro',
    isa         => 'Str',
    lazy        => 1,
    default     => sub {
        return ucfirst(shift->name);
    },
);

has hidden => (
    is          => 'ro',
    isa         => 'Bool',
    default     => 0,
);

has sortable => (
    is          => 'ro',
    isa         => 'Bool',
    default     => 0,
);

# For overriding the sort_by column. Meaningless
# unless sortable is set
has sort_by => (
    is          => 'ro',
    isa         => 'Str',
    lazy        => 1,
    default     => sub {
        return shift->name;
    },
);

# Optional CSS for cells in this column
has cell_class => (
    is          => 'ro',
    isa         => 'Str',
    predicate   => 'has_cell_class',
);

# If you need to override the default content.
# Default is HTML-escaped value from DB field.
# TODO Document how this is called.
has content => (
    is          => 'ro',
    isa         => 'CodeRef',
    predicate   => 'has_content',
);

# If present, wraps the default content in a <a> link
# with this as the URL
has link => (
    is          => 'ro',
    isa         => 'CodeRef',
    predicate   => 'has_link',
);

# Set this if we are to format the column as a timestamp.
# The cell value must be a DateTime object
has timestamp => (
    is          => 'ro',
    isa         => 'Bool',
    default     => 0,
);

# Unicode characters for sort triangles, with any necessary css
has _active_arrow_down => (
    is          => 'ro',
    isa         => 'Str',
    default     => '<span class="sort-arrow sort-arrow-down sort-arrow-down-active">▼</span>',
);

has _active_arrow_up => (
    is          => 'ro',
    isa         => 'Str',
    default     => '<span class="sort-arrow sort-arrow-up sort-arrow-up-active">▲</span>',
);

has _inactive_arrow_down => (
    is          => 'ro',
    isa         => 'Str',
    default     => '<span class="sort-arrow sort-arrow-down sort-arrow-down-inactive">▽</span>',
);

has _inactive_arrow_up => (
    is          => 'ro',
    isa         => 'Str',
    default     => '<span class="sort-arrow sort-arrow-up sort-arrow-up-inactive">△</span>',
);

sub render_header_cell {
    my ($self, $table) = @_;

    return '' if $self->hidden;

    my $paginator = $table->paginator;
    my $s = encode_entities($self->header);
    if ($self->sortable) {
		$s .= ' ' . $self->_link_down($paginator, '▼', '▽');
		$s .= ' ' . $self->_link_up($paginator, '▲', '△');
    }

    return qq{<th>$s</th>};
}

sub _link_up_down {
	my ($self, $paginator, $dir, $label_on, $label_off) = @_;

	my $args = {
		sort_dir => $dir,
		order_by => $self->name,
	};
	return $self->_make_link($paginator, $dir, $label_on, $label_off, $args);
}

sub _link_down {
	my ($self, $paginator, $label_on, $label_off) = @_;

	return $self->_link_up_down($paginator, 'd', $self->_active_arrow_down, $self->_inactive_arrow_down);
}

sub _link_up {
	my ($self, $paginator, $label_on, $label_off) = @_;

	return $self->_link_up_down($paginator, 'u', $self->_active_arrow_up, $self->_inactive_arrow_up);
}

sub _make_link {
	my ($self, $paginator, $dir, $label_on, $label_off, $args) = @_;

	if ($paginator->order_col->name eq $self->name && $paginator->sort_dir eq $dir) {
		return $label_on;
	}
	else {
		my @kvs;
		foreach my $k (qw/ page page_size order_by sort_dir /) {
			my $v = exists $args->{$k} ? $args->{$k} : $paginator->$k;
			push @kvs, $k . '=' . uri_escape($v);
		}

		my $url = '?' . join('&', @kvs);
		return qq{<a href="$url">$label_off</a>};
	}
}

# TODO Tests
sub render_body_cell {
    my ($self, $table, $row) = @_;

    return '' if $self->hidden;

    my $s;
    if ($self->has_content) {
        $s =  $self->content->($self, $table, $row);
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

    my $class = $self->has_cell_class
        ? 'class="' . $self->cell_class . '"'
        : '';

    $s //= '';
    return qq{<td $class>$s</td>};
}

__PACKAGE__->meta->make_immutable;
1;
