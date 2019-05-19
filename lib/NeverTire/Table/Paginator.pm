package NeverTire::Table::Paginator;
use Moose;
use namespace::autoclean;

use utf8;

has page => (
    is			=> 'ro',
    isa			=> 'Int',
    required    => 1,
);

has page_size => (
    is			=> 'ro',
    isa			=> 'Int',
    required    => 1,
);

has order_by => (
    is			=> 'ro',
    isa			=> 'Str',
    predicate   => 'has_order_by',
);

has order_col => (
    is			=> 'ro',
    isa			=> 'NeverTire::Table::Column',
    predicate   => 'has_order_col',
);

has sort_dir => (
    is			=> 'ro',
    isa			=> 'Str',   # 'u' or 'd'
    required    => 1,
);

has row_count => (
    is			=> 'ro',
    isa			=> 'Int',
    required    => 1,
);

has page_count => (
    is			=> 'ro',
    isa			=> 'Int',
    lazy        => 1,
    default     => sub {
        my $self = shift;

        my $rc = $self->row_count;
        my $ps = $self->page_size;
        return int(($ps + $rc - 1) / $ps);
    },
);


sub paginate_rs {
    my ($self, $rs) = @_;

    my $ps = $self->page_size;

    my %sort_opts = ();

    if ($self->has_order_by) {
        my $sort_dir = $self->sort_dir eq 'u' ? '-asc' : '-desc';
        $sort_opts{order_by} = {$sort_dir => $self->order_by};
    }
    elsif ($self->has_order_col) {
        my $sort_dir = $self->sort_dir eq 'u' ? '-asc' : '-desc';
        $sort_opts{order_by} = {$sort_dir => $self->order_col->sort_by};
    }
    return $rs->search(undef, {
        offset   => ($self->page - 1) * $ps,
        rows     => $ps,
        %sort_opts,
    });
}

# Returns numbers representing the pages we should link to
# Where we should replace a bunch of pages with an ellipsis,
# return undef.
#
# e.g. if we want links to pages 1, 8, 9, 10, 20 then we're
# going to return [1, undef, 8, 9, 10, undef, 20]

sub _calc_page_links {
    my $self = shift;

    my $cp = $self->page;
    my $pc = $self->page_count;

    # Start with the full range of pages, e.g. 1 .. 20
    # Replace with undef the range 2 .. $current-$width (if > 1 item)
    # Replace with undef the range $current+width .. $page_count (if > 1 item)
    my @v = (1 .. $pc);

    my $max = $cp + 1;
    if ($max < $pc - 2) {
        my $len = $pc - $max - 1;
        splice @v, $max, $len, undef;
    }

    my $min = $cp - 1;
    if ($min > 3) {
        my $len = $min - 2;
        splice @v, 1, $len, undef;
    }

    return \@v;
}

sub render {
    my $self = shift;

    my $cp = $self->page;
    my $pc = $self->page_count;

    if ($pc == 1) {
        return '';
    }

    my $pages = $self->_calc_page_links($cp);
    my $s = q{
        <div class="pagination">
    };

    # Render 'previous' unless we're on the last page.
    if ($cp != 1) {
        my $pm1 = $cp - 1;
        $s .= qq{<a href="?page=$pm1">⇦</a>};
    }

    foreach my $page (@$pages) {
        if (defined($page)) {
            if ($page == $cp) {
                $s .= qq{<a class="active" href="?page=$page">${page}</a>\n};
            }
            else {
                $s .= qq{<a href="?page=$page">${page}</a>\n};
            }
        }
        else {
            $s .= qq{<span class="pagination-gap">&hellip;</span>\n};
        }
    }

    # Render 'next' unless we're on the last page.
    if ($cp != $pc) {
        my $pp1 = $cp + 1;
        $s .= qq{<a href="?page=$pp1">⇨</a>};
    }

    return $s . q{
        </div>
    };
}

sub BUILD {
    my $self = shift;

    if ($self->has_order_col) {
        my $sort_dir = $self->sort_dir;
        die 'Invalid sort options' unless $sort_dir eq 'u' || $sort_dir eq 'd';
    }
}

__PACKAGE__->meta->make_immutable;
1;
