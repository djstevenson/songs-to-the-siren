package NeverTire::Schema::Result::Song;
use Moose;
use namespace::autoclean;

extends 'NeverTire::Schema::Base::Result';

# TODO POD

use NeverTire::Model::Comment::Forest;

use DateTime;

__PACKAGE__->load_components('InflateColumn::DateTime');

__PACKAGE__->table('songs');

__PACKAGE__->add_columns(
    id               => {data_type => 'INTEGER'},
    artist           => {data_type => 'TEXT'},
    title            => {data_type => 'TEXT'},
    album            => {data_type => 'TEXT'},

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

__PACKAGE__->belongs_to(author => 'NeverTire::Schema::Result::User',   { 'foreign.id' => 'self.author_id' });

__PACKAGE__->has_many( song_tags => 'NeverTire::Schema::Result::SongTag', { 'foreign.song_id' => 'self.id' });
__PACKAGE__->has_many( comments  => 'NeverTire::Schema::Result::Comment', { 'foreign.song_id' => 'self.id' });

__PACKAGE__->many_to_many( tags => song_tags => 'tags');

sub approved_comments {
    my $self = shift;

    return $self->comments->search({ approved_at => { '!=' => undef }});
}

sub show {
    shift->update({ published_at => DateTime->now });
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
sub comment_tree {
    my $self = shift;

    return NeverTire::Model::Comment::Forest
        ->new
        ->make_forest($self);
}


no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;
