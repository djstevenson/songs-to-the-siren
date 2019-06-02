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

        my @current_ids = split(/,/, $qp);
        my @new_ids = ();

        my $remove_id = $tag->id;
        foreach my $id ( @current_ids ) {
            push @new_ids, $id unless $id == $remove_id;
        }

        return '' unless scalar(@new_ids);

        return '?tags=' . join(',', @new_ids);
    });

  

    # TODO Tests for helpers
}

1;
