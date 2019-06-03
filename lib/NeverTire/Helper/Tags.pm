package NeverTire::Helper::Tags;
use Mojo::Base 'Mojolicious::Plugin';

use NeverTire::Util::List qw/ add_id_to_list remove_id_from_list /;

sub register {
    my ($self, $app) = @_;

    # $tag is a Tag result object
    # Returns '' or '?tags=n,m,p'
    $app->helper(remove_tag_from_query_params => sub {
        my ($c, $tag) = @_;

        my @ids = remove_id_from_list($c->param('tags'), $tag->id);

        return '' unless scalar(@ids);

        return '?tags=' . join(',', @ids);
    });

    # $tag is a Tag result object
    # Returns ?tags=n,m,p'
    $app->helper(add_tag_to_query_params => sub {
        my ($c, $tag) = @_;

        my @ids = add_id_to_list($c->param('tags'), $tag->id);

        return '?tags=' . join(',', @ids);
    });

  

    # TODO Tests for helpers
}



1;

__END__


=pod

=head1 NAME

NeverTire::Helper::Tags : helper to mangle tag-related query params

=head1 SYNOPSIS

    # In app startup()
    $self->plugin('NeverTire::Helper::Tags');

    add_tag_to_query_params($tag);
    remove_tag_from_query_params($tag);

=head1 DESCRIPTION

Provides helpers for manipulating tag-related query params

=head1 HELPERS

=over

=item add_tag_to_query_params

    $c->add_tag_to_query_params($tag)

Adds the id for the specified tag to the query params.

Returns a string that can be used in a template, e.g. "?tag=4,5"

Does de-duping.

=item remove_tag_from_query_params

    $c->remove_tag_from_query_params($tag)

Removes the id for the specified tag from the query params.

Returns a string that can be used in a template, e.g. "?tag=4,5"

Returns the empty string if the removed tag was the only one present.

=back

=head1 AUTHOR

David Stevenson david@ytfc.com
