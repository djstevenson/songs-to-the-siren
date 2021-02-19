package SongsToTheSiren::Controller::Admin;
use utf8;
use Mojo::Base 'Mojolicious::Controller';

use SongsToTheSiren::Controller::Admin::Song;
use SongsToTheSiren::Controller::Admin::Content;

use File::Path qw/ rmtree mkpath /;

sub add_routes {
    my ($c, $r) = @_;

    my $a = $r->any('/admin')->require_admin;

    $a->get(q{/})->name('admin_home')->to('admin#home');
    $a->get(q{/export})->name('admin_export')->to('admin#export');

    SongsToTheSiren::Controller::Admin::Song->new->add_routes($a);
    SongsToTheSiren::Controller::Admin::Content->new->add_routes($a);
    
    return;
}

sub export {
    my $c = shift;

    my $export_dir = '/tmp/songs';
    rmtree($export_dir) if -d $export_dir;
    mkpath($export_dir, { mode => 0755 });

    my $songs_rs = $c->schema->resultset('Song');
    while (my $song = $songs_rs->next) {
        $song->export($export_dir);
    }

    $c->flash(msg => "Exported to $export_dir");
    $c->redirect_to('admin_home');
}

1;
