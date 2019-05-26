package NeverTire::Table::Base;
use Moose;
use namespace::autoclean;

use NeverTire::Table::Paginator;

use Scalar::Util qw/ blessed /;

has c => (
	is			=> 'ro',
	isa			=> 'Mojolicious::Controller',
	required    => 1,
);

has resultset => (
	is			=> 'ro',
	isa			=> 'DBIx::Class::ResultSet',
	required    => 1,
    builder     => '_build_resultset',
);

has table_columns => (
	is			=> 'ro',
	isa			=> 'ArrayRef[NeverTire::Table::Column]',
	required	=> 1,
    writer      => '_set_columns',
	default		=>  sub{ ref(shift)->meta->table_columns },
);

has show_header => (
    is			=> 'ro',
    isa			=> 'Bool',
    lazy        => 1,
    init_arg    => undef,
    default     => 1,
);

has page => (
    is			=> 'ro',
    isa			=> 'Int',
    lazy        => 1,
    init_arg    => undef,
    default     => sub { return shift->c->req->param('page') || 1; },
);

# TODO Put default page size (etc) in config somewhere
has page_size => (
    is			=> 'ro',
    isa			=> 'Int',
    lazy        => 1,
    init_arg    => undef,
    default     => sub { return shift->c->req->param('page_size') || 12; },
);

# Value is a COLUMN NAME, not a database field
has order_by => (
    is			=> 'ro',
    isa			=> 'Str',
    lazy        => 1,
    init_arg    => undef,
    default     => sub {
        my $self = shift;
        return $self->c->req->param('order_by') || $self->default_order_by;
    },
);

has default_order_by => (
    is			=> 'ro',
    isa			=> 'Str',
    lazy        => 1,
    init_arg    => undef,
    default     => 'id',
);

has sort_dir => (
    is			=> 'ro',
    isa			=> 'Str',
    lazy        => 1,
    init_arg    => undef,
    default     => sub {
        my $self = shift;
        return $self->c->req->param('sort_dir') || $self->default_sort_dir;
    },
);

has default_sort_dir => (
    is			=> 'ro',
    isa			=> 'Str',
    lazy        => 1,
    init_arg    => undef,
    default     => 'd',
);

# Override default
has empty_text => (
    is			=> 'ro',
    isa			=> 'Str',
    default     => 'No data',
);

has row_count => (
    is          => 'ro',
    isa         => 'Int',
    lazy        => 1,
    init_arg    => undef,
    builder     => '_build_row_count',
);

has paginator => (
    is          => 'ro',
    isa         => 'NeverTire::Table::Paginator',
    lazy        => 1,
    init_arg    => undef,
    builder     => '_build_paginator',
);

has id => (
    is          => 'ro',
    isa         => 'Str',
    lazy        => 1,
    init_arg    => undef,
    builder     => '_build_id',
);

# So NeverTire::Table::Announcement::List
# becomes
# table-announcement-list
sub _build_id {
    my $self = shift;

    my $class = blessed($self);
    $class =~ s/^NeverTire:://;

    $class =~ s/::/-/g;

    return lc $class;
}

sub _build_row_count {
    my $self = shift;

    return $self->resultset->count;
}

sub _build_paginator {
    my $self = shift;

    return NeverTire::Table::Paginator->new(
        page      => $self->page,
        page_size => $self->page_size,
        order_col => $self->_order_column,
        sort_dir  => $self->sort_dir,
        row_count => $self->row_count,
    );
}

sub _order_column {
    my $self = shift;

    foreach my $col (@{ $self->table_columns }) {
        return $col if $col->name eq $self->order_by;
    }
    return undef;
}

sub render {
    my $self = shift;

    my $id = $self->id;

    my $row_count = $self->row_count;

    if ($row_count) {
        return qq{<div id="${id}" class="non-empty-table">} . $self->_data_render . q{</div>};
    }
    else {
        return qq{<div id="${id}" class="is-empty-table"><p>} . $self->empty_text . q{</p></div>};
    }
}

sub _data_render {
    my $self = shift;

    my $header = $self->show_header ? $self->_render_header : '';

    return
        '<table class="table table-hover table-sm">'
            . $header
            . $self->_render_body
        . '</table>'
        . $self->paginator->render;
}

sub _render_header {
    my $self = shift;

    my $s;
    foreach my $col (@{ $self->table_columns }) {
        $s .= $col->render_header_cell($self);
    }

    return '<thead class="thead-dark"><tr>' . $s . '</tr></thead>';
}

sub _render_body {
    my $self = shift;

    my $s;

    my $rs = $self->paginator->paginate_rs($self->resultset);
    while (my $row = $rs->next) {
        my $row_class = '';
        if (my $class = $self->class_for_row_data($row)) {
            $row_class = qq{class="$class"};
        }
        $s .= qq{<tr ${row_class}">};
        foreach my $col (@{ $self->table_columns }) {
            $s .= $col->render_body_cell($self, $row);
        }
        $s .= '</tr>';
    }

    return '<tbody>' . $s . '</tbody>';
}

sub BUILD {
	my $self = shift;

    my $sort_dir = $self->sort_dir;
    die 'Invalid sort options' unless $sort_dir eq 'u' || $sort_dir eq 'd';
}


# Override this if you want to return a different TR class
# depending on row data.
sub class_for_row_data {
    return undef;
}

__PACKAGE__->meta->make_immutable;
1;
