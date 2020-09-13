package SongsToTheSiren::Schema::ResultSet::Comment;
use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';

# POD docs at end of this source file

use Carp qw/ croak /;

use DateTime;

# TODO Use this pattern for songs etc too?
#      for_display reads better than the lower-level
#      methods currently implemented there.
sub for_display {
    my $self = shift;

    # Add the author name to the search
    return $self->search(undef, {'+select' => ['author.name'], '+as' => ['author_name'], join => 'author',});
}

sub for_user {
    my ($self, $user) = @_;

    my $rs;
    if ($user) {
        if ($user->admin) {

            # Admin user sees everything
            $rs = $self;
        }
        else {
            # Non-admin user sees modded comments
            # and OWN non-modded ones.
            $rs = $self->search({
                -or => [
                    { approved_at => { q{!=} => undef} },
                    { author_id   => $user->id         }
                ]
            });
        }
    }
    else {
        # Not logged-in, sees modded comments only
        $rs = $self->search({
            approved_at => { q{!=} => undef}
        });
    }

    return $rs;
}

sub id_order {
    my $self = shift;

    return $self->search(undef, {order_by => {-asc => 'id'}});
}

__PACKAGE__->meta->make_immutable;
1;

=pod

=head1 NAME

SongsToTheSiren::Schema::ResultSet::Comment : ResultSet subclass for song comments

=head1 SYNOPSIS

    my $rs = $schema->resultset('Comment');
    $rs->select_approved-> ...;

=head1 DESCRIPTION

ResultSet methods for Comments

=head1 METHODS

=over

=item where_approved

Adds a clause to the resultset so that only
approved comments are selected.

=item id_order

Order by id ascending - oldest comments first.

=back

=head1 AUTHOR

David Stevenson david@ytfc.com

=cut

