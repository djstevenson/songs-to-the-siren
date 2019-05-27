package NeverTire::Controller::Song::Tag;
use Mojo::Base 'Mojolicious::Controller';

# $rl = base route for '/song/:id' tag admin actions

sub add_routes {
    my ($c, $rl) = @_;

    my $ul = $rl->any('/tag')->to(controller => 'Song::Tag');

    # These are admin functions, need to be logged in for all of them.
    $ul->route('/edit')->name('edit_song_tags')->via('GET')->to(action => 'edit');
}


sub edit {
    my $c = shift;

    my $tags = $c->stash->{song}->tags;
    $c->stash(tags => [ $tags->all ]);
}

1;
