package SongsToTheSiren::Util::Date;
use strict;
use warnings;

# TODO POD docs

# TODO Tests
# TODO Tests that take different timezones into account
use Sub::Exporter -setup => {exports => [qw/ format_date format_date_nosec format_pg_date format_date_compact /]};

use DateTime::Format::Pg;

sub format_date {
    return shift->strftime('%a, %e %b %Y %H:%M:%S');
}

sub format_date_nosec {
    return shift->strftime('%a, %e %b %Y %H:%M');
}

sub format_date_compact {
    return shift->strftime('%F %T');
}

sub format_pg_date {
    return format_date(DateTime::Format::Pg->parse_datetime(shift));
}

1;
