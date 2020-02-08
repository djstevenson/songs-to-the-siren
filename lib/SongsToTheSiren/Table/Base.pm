package SongsToTheSiren::Table::Base;
use Moose;
use namespace::autoclean;

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
    lazy        => 1,
);

has table_columns => (
	is			=> 'ro',
	isa			=> 'ArrayRef[SongsToTheSiren::Table::Column]',
	required	=> 1,
	default		=>  sub{ ref(shift)->meta->table_columns },
    lazy        => 1,
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

has id => (
    is          => 'ro',
    isa         => 'Str',
    lazy        => 1,
    init_arg    => undef,
    builder     => '_build_id',
);

# So SongsToTheSiren::Table::Announcement::List
# becomes
# table-announcement-list
sub _build_id {
    my $self = shift;

    my $class = blessed($self);
    $class =~ s/^SongsToTheSiren:://;

    $class =~ s/::/-/g;

    return lc $class;
}

sub _build_row_count {
    my $self = shift;

    return $self->resultset->count;
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
        '<table class="table table-striped table-dark table-borderless">'
            . $header
            . $self->_render_body
        . '</table>'
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

    my $rs = $self->resultset;
    while (my $row = $rs->next) {
        my $row_class = '';
        if (my $class = $self->class_for_row_data($row)) {
            $row_class = qq{class="$class"};
        }
        $s .= qq{<tr ${row_class}>};
        foreach my $col (@{ $self->table_columns }) {
            $s .= $col->render_body_cell($self, $row);
        }
        $s .= '</tr>';
    }

    return '<tbody>' . $s . '</tbody>';
}

# Override this if you want to return a different TR class
# depending on row data.
sub class_for_row_data {
    return undef;
}

__PACKAGE__->meta->make_immutable;
1;
