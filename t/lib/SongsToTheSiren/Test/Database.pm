package SongsToTheSiren::Test::Database;
use utf8;
use Moose;
use namespace::autoclean;

use DBI;

use Try::Tiny;

has test_name => (
    is          => 'ro',
    isa         => 'Str',
    required    => 1,
);

has db_name => (
    is          => 'ro',
    isa         => 'Str',
    lazy        => 1,
    init_arg    => undef,
    builder     => '_build_db_name',
);

sub _build_db_name {
    my $self = shift;

    my @tm = localtime;
    return sprintf('test_%04d%02d%02d_%02d%02d%02d_%d_%d_%s',
        1900 + $tm[5],
        1 + $tm[4],
        $tm[3],
        $tm[2],
        $tm[1],
        $tm[0],
        $$,
        rand(10_000),
        $self->test_name,
    );
}

sub BUILD {
    my $self = shift;

    my $db_name = $self->db_name;

    # TODO Credentials from config
    $self->meta_db_action('CREATE DATABASE ' . $db_name . ' WITH OWNER = songstothesiren');
}

sub DEMOLISH {
    my $self = shift;

    my $db_name = $self->db_name;

    # Try a few times, cos something else might access
    # Vacuum seems to do it.
    foreach my $i ( 1 .. 10 ) {
        my $ok;
        try {
            $self->meta_db_action('DROP DATABASE ' . $db_name);
            $ok = 1;
        }
        catch {
            my $e = shift;
            print "Error zapping DB, will retry: $e\n";
            sleep 3;
        };
        last if $ok;
    }
}

sub meta_db_action {
    my ($self, $sql) = @_;

    my $data_source = 'dbi:Pg:database=postgres';
    my $dbh = DBI->connect($data_source, 'postgres', undef, {RaiseError => 1});

   $dbh->do($sql);
}

__PACKAGE__->meta->make_immutable;
1;
