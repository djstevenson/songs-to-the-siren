package SongsToTheSiren::Util::QueryParams;
use strict;
use warnings;

# TODO POD
use Sub::Exporter -setup => {exports => [qw/ add_id_to_param remove_id_from_param /]};

use SongsToTheSiren::Util::List qw/ add_id_to_list remove_id_from_list /;

sub add_id_to_param {
    my ($list, $name, $id_add) = @_;

    return _join_tags($name, add_id_to_list($list, $id_add));
}

sub _join_tags {
    my ($name, @tags) = @_;

    return '' unless scalar(@tags);

    return '?' . $name . '=' . join(',', @tags);
}

sub remove_id_from_param {
    my ($list, $name, $id_remove) = @_;

    return _join_tags($name, remove_id_from_list($list, $id_remove));
}

1;
