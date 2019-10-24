package NeverTire::Schema::Result::Song;
use Moose;
use namespace::autoclean;

extends 'NeverTire::Schema::Base::Result';

# TODO POD

use NeverTire::Model::Comment::Forest qw/ make_forest /;

use DateTime;
use Text::Markdown qw/ markdown /;

__PACKAGE__->load_components('InflateColumn::DateTime');

__PACKAGE__->table('songs');

__PACKAGE__->add_columns(
    id               => {data_type => 'INTEGER'},
    artist           => {data_type => 'TEXT'},
    title            => {data_type => 'TEXT'},
    album            => {data_type => 'TEXT'},
    image            => {data_type => 'TEXT'},
    country_id       => {data_type => 'INTEGER'},

    summary_markdown => {data_type => 'TEXT'},
    summary_html     => {data_type => 'TEXT'},
    full_markdown    => {data_type => 'TEXT'},
    full_html        => {data_type => 'TEXT'},

    author_id        => {data_type => 'INTEGER'},

    created_at       => {data_type => 'DATETIME'},
    updated_at       => {data_type => 'DATETIME'},
    published_at     => {data_type => 'DATETIME'},

    # TEXT so it can be free-format, e.g. "summer 1991"
    released_at      => {data_type => 'TEXT'},
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to( author    => 'NeverTire::Schema::Result::User',     { 'foreign.id' => 'self.author_id'  }, { join_type	=> 'LEFT' } );
__PACKAGE__->belongs_to( country   => 'NeverTire::Schema::Result::Country',  { 'foreign.id' => 'self.country_id' }, { join_type	=> 'LEFT' } );

__PACKAGE__->has_many  ( song_tags => 'NeverTire::Schema::Result::SongTag',  { 'foreign.song_id' => 'self.id'    });
__PACKAGE__->has_many  ( comments  => 'NeverTire::Schema::Result::Comment',  { 'foreign.song_id' => 'self.id'    });
__PACKAGE__->has_many  ( links     => 'NeverTire::Schema::Result::Link',     { 'foreign.song_id' => 'self.id'    });

__PACKAGE__->many_to_many( tags => song_tags => 'tags');

sub approved_comments {
    my $self = shift;

    return $self->comments->search({ approved_at => { '!=' => undef }});
}

sub show {
    my $self = shift;
    $self->update({ published_at => \'NOW()' });
    $self->discard_changes;
}

sub hide {
    shift->update({ published_at => undef });
}

sub add_tag {
    my ($self, $tag_name) = @_;

    my $rs = $self->result_source->schema->resultset('Tag');
    my $tag = $rs->find_or_create({ name => $tag_name });

    $rs = $self->result_source->schema->resultset('SongTag');
    return $rs->find_or_create({
        tag_id  => $tag->id,
        song_id => $self->id,
    });
}

sub delete_tag {
    my ($self, $tag) = @_;

    $self->song_tags->search({
        tag_id => $tag->id
    })->delete;

    # Remove if no-longer associated with any songs
    $tag->delete if $tag->songs->count == 0;
}

# TODO DOCUMENT THIS
# Returns reference to ordered array of
# NeverTire::Model::Comment::Node
#
# Unmoderated comments are included IFF $admin is
# true.
sub get_comment_forest {
    my ($self, $admin) = @_;

    return make_forest($self, $admin);
}

sub add_comment {
    my ($self, $user, $reply_to, $markdown) = @_;

    # Whitelist fields from $data, and add
    # in default values where needed.
    my $parent_id = $reply_to ? $reply_to->id : undef;

    my $comment_data = {
        song_id          => $self->id,
        author_id        => $user->id,
        parent_id        => $parent_id,
        comment_markdown => $markdown,
        comment_html     => markdown($markdown),
        created_at       => DateTime->now
    };

    return $self->create_related(comments => $comment_data);
}

sub add_link {
    my ($self, $values) = @_;

    return $self->links->create({
        name     => $values->{name},
        url      => $values->{url},
        priority => $values->{priority},
        extras   => $values->{extras},
    });
}

# returns {
#    newer => $next_newer_song,
#    older => $next_older_song,
# }
# Either song can be undef (no older/newer song).

sub get_navigation {
    my $self = shift;

    return {
        newer => $self->newer,
        older => $self->older,
    };
}

sub newer {
    my $self = shift;

    return $self
        ->result_source
        ->resultset
        ->newer($self)
        ->where_published
        ->single;
}

sub older {
    my $self = shift;

    return $self
        ->result_source
        ->resultset
        ->older($self)
        ->where_published
        ->single;
}

no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;
