package NeverTire::Util::Date;
use strict;
use warnings;


# TODO Tests
# TODO Tests that take different timezones into account
use Sub::Exporter -setup => {
    exports => [qw/ format_date format_pg_date /]
};

use DateTime::Format::Pg;

sub format_date {
    return shift->strftime('%a, %e %b %Y %H:%M:%S');
}

sub format_pg_date {
    return format_date(DateTime::Format::Pg->parse_datetime(shift));
}

1;
