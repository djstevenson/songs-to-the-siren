package NeverTire::Util::List;

# TODO POD
use Sub::Exporter -setup => {
    exports => [qw/ add_id_to_list remove_id_from_list /]
};


sub add_id_to_list {
    my ($list, $add) = @_;

    # Remove the id from the list if present then append it
    my @ids = remove_id_from_list($list, $add);
    push @ids, $add;

    return @ids;
}

sub remove_id_from_list {
    my ($list, $remove) = @_;

    my @ids = ();

    @ids = split(/,/, $list) if $list;

    my @new_ids;

    foreach my $id (@ids) {
        push @new_ids, $id unless $id == $remove;
    }

    return @new_ids;
}

1;
