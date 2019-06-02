package NeverTire::Helper::TagQueryParams;
use Mojo::Base 'Mojolicious::Plugin';

use NeverTire::Util::Date qw/ format_date     /;

use HTML::Entities    qw/ encode_entities /;

# TODO POD

sub register {
    my ($self, $app) = @_;

    # $tag is a Tag result object
    # Returns '' or '?tags=n,m,p'
    $app->helper(remove_tag_from_query_params => sub {
        my ($c, $tag) = @_;

        my $qp = $c->param('tags');
        return '' unless $qp;

        my @ids = split(/,/, $qp);

        @ids = _remove_element($tag->id, @ids);

        return '' unless scalar(@ids);

        return '?tags=' . join(',', @ids);
    });

    # $tag is a Tag result object
    # Returns ?tags=n,m,p'
    $app->helper(add_tag_to_query_params => sub {
        my ($c, $tag) = @_;

        my $qp = $c->param('tags');
        my @ids = $qp ? split(/,/, $qp) : ();

        my $new_tag_id = $tag->id;
        @ids = _remove_element($new_tag_id, @ids);
        push @ids, $new_tag_id;

        return '?tags=' . join(',', @ids);
    });

  

    # TODO Tests for helpers
}

sub _remove_element {
    my ($element, @old_array) = @_;

    my @new_array;
    foreach my $id (@old_array) {
        push @new_array, $id unless $id == $element;
    }

    return @new_array;
}

1;
