package SongsToTheSiren::Helper::Render;
use Mojo::Base 'Mojolicious::Plugin';

use SongsToTheSiren::Util::Date qw/ format_date format_date_nosec format_date_compact /;

use HTML::Entities qw/ encode_entities /;

# TODO POD

sub register {
    my ($self, $app) = @_;

    # Currently only allows for adding 's' for plurals
    # TODO Fix this
    # TODO Tests
    # TODO POD
    # TODO Surely there's a CPAN module that already does this?!
    $app->helper(
        pluralise => sub {
            my ($c, $value, $label) = @_;

            $value //= 0;

            my $id = $self->_label_to_id($label);
            return
                sprintf(q{<span id="%s">%d</span> %s%s}, $id, $value, encode_entities($label), $value == 1 ? '' : 's');
        }
    );

    # Currently only allows for adding 's' for plurals
    # TODO Fix this.
    # TODO Tests
    # Links to specified URL if non-zero
    # TODO POD
    $app->helper(
        pluralise_link => sub {
            my ($c, $value, $label, $url) = @_;

            $value //= 0;

            my $text = $c->pluralise($value, $label);

            return $text if $value == 0;

            return qq{<a class="u" href="$url">$text</a>};
        }
    );

    # datetime arg is a DateTime object. Can be NULL in which case
    # we return the default value (which itself defaults
    # to empty string).
    # e.g. Sat, 18 Apr 2020 22:10:12
    $app->helper(
        datetime => sub {
            my ($c, $datetime, $default) = @_;

            return $default // '' unless $datetime;

            return format_date($datetime);
        }
    );

    # datetime arg is a DateTime object. Can be NULL in which case
    # we return the default value (which itself defaults
    # to empty string). Format is like datetime but
    # without the seconds
    # e.g. 2020-04-18 22:10
    $app->helper(
        datetime_nosec => sub {
            my ($c, $datetime, $default) = @_;

            return $default // '' unless $datetime;

            return format_date_nosec($datetime);
        }
    );

    # datetime arg is a DateTime object. Can be NULL in which case
    # we return the default value (which itself defaults
    # to empty string). Format is SQL-style
    # e.g. 2020-04-18 22:10:12
    $app->helper(
        datetime_compact => sub {
            my ($c, $datetime, $default) = @_;

            return $default // '' unless $datetime;

            return format_date_compact($datetime);
        }
    );

    # Value arg is something we can evaluate to true or false,
    # for which we output the $true or $false value
    # respecively. These default to 'Yes' and 'No'.
    $app->helper(
        bool => sub {
            my ($c, $value, $true, $false) = @_;

            if ($value) {
                return $true // 'Yes';
            }
            else {
                return $false // 'No';
            }
        }
    );
}

# TODO Tests for helpers

sub _label_to_id {
    my ($self, $label) = @_;

    my $result = $label;

    $label =~ s/\s/-/g;

    return 'count-' . $label . 's';
}
1;
