package SongsToTheSiren::Schema::Result::Song;
use utf8;
use Moose;
use namespace::autoclean;

extends 'SongsToTheSiren::Schema::Base::Result';

# TODO POD

use SongsToTheSiren::Model::Comment::Forest qw/ make_forest /;

use DateTime;
use Text::Markdown qw/ markdown /;
use IO::File;
use File::Path qw/ mkpath /;

__PACKAGE__->load_components('InflateColumn::DateTime');

__PACKAGE__->table('songs');

__PACKAGE__->add_columns(
    id     => {data_type => 'INTEGER', is_auto_increment => 1 },
    artist => {data_type => 'TEXT'},
    title  => {data_type => 'TEXT'},
    album  => {data_type => 'TEXT'},

    # Image name, and available resolutions.
    # Image files should be in
    # public/images/artwork
    #
    # Each file should be:
    # <name>-1x.jpg etc
    #
    # The highest resolution available is stored
    # in max_resolution. So, if that is 4, then
    # we will expect 1x, 2x, 3x, and 4x images.
    image          => {data_type => 'TEXT'},
    max_resolution => {data_type => 'INTEGER'},

    country => {data_type => 'TEXT'},

    summary_markdown => {data_type => 'TEXT'},
    summary_html     => {data_type => 'TEXT'},
    full_markdown    => {data_type => 'TEXT'},
    full_html        => {data_type => 'TEXT'},

    author_id => {data_type => 'INTEGER'},

    created_at   => {data_type => 'DATETIME'},
    updated_at   => {data_type => 'DATETIME'},
    published_at => {data_type => 'DATETIME'},

    # TEXT so it can be free-format, e.g. "summer 1991"
    released_at => {data_type => 'TEXT'},
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(
    author => 'SongsToTheSiren::Schema::Result::User',
    {'foreign.id' => 'self.author_id'}, {join_type => 'LEFT'}
);

__PACKAGE__->has_many(song_tags => 'SongsToTheSiren::Schema::Result::SongTag', {'foreign.song_id' => 'self.id'});
__PACKAGE__->has_many(comments  => 'SongsToTheSiren::Schema::Result::Comment', {'foreign.song_id' => 'self.id'});
__PACKAGE__->has_many(links     => 'SongsToTheSiren::Schema::Result::Link',    {'foreign.song_id' => 'self.id'});

__PACKAGE__->many_to_many(tags => song_tags => 'tags');

sub approved_comments {
    my $self = shift;

    return $self->comments->search({
        approved_at => { q{!=} => undef }
    });
}

sub show {
    my $self = shift;
    $self->update({published_at => \'NOW()'});
    $self->discard_changes;

    return;
}

sub hide {
    shift->update({published_at => undef});

    return;
}

sub add_tag {
    my ($self, $tag_name) = @_;

    my $rs  = $self->result_source->schema->resultset('Tag');
    my $tag = $rs->find_or_create({name => $tag_name});

    $rs = $self->result_source->schema->resultset('SongTag');
    return $rs->find_or_create({tag_id => $tag->id, song_id => $self->id,});
}

sub delete_tag {
    my ($self, $tag) = @_;

    $self->song_tags->search({tag_id => $tag->id})->delete;

    # Remove if no-longer associated with any songs
    $tag->delete if $tag->songs->count == 0;

    return;
}

# TODO DOCUMENT THIS
# Returns reference to ordered array of
# SongsToTheSiren::Model::Comment::Node
#
# Unmoderated comments are included IFF $admin is
# true.
sub get_comment_forest {
    my ($self, $user) = @_;

    return make_forest($self, $user);
}

sub add_link {
    my ($self, $values) = @_;

    return $self->links->create({
        embed_identifier  => $values->{embed_identifier}  || q{},
        embed_class       => $values->{embed_class}       || q{},
        embed_url         => $values->{embed_url}         || q{},
        embed_description => $values->{embed_description} || q{},
        list_url          => $values->{list_url}          || q{},
        list_description  => $values->{list_description}  || q{},
        list_priority     => $values->{list_priority},
        list_css          => $values->{list_css}          || q{},
    });
}

sub render_markdown {
    my $self = shift;

    my $processor = SongsToTheSiren::Markdown->new(song => $self);
    $self->update({
        full_html    => $processor->markdown($self->full_markdown),
        summary_html => $processor->markdown($self->summary_markdown),
    });

    return;
}

# returns {
#    newer => $next_newer_song,
#    older => $next_older_song,
# }
# Either song can be undef (no older/newer song).

sub get_navigation {
    my $self = shift;

    return {newer => $self->newer, older => $self->older,};
}

sub newer {
    my $self = shift;

    # Nothing if this song isn't published
    return undef unless $self->published_at;

    return $self->result_source->resultset->newer($self)->where_published->single;
}

sub older {
    my $self = shift;

    # Nothing if this song isn't published
    return undef unless $self->published_at;

    return $self->result_source->resultset->older($self)->where_published->single;
}

sub export {
    my ($self, $root_dir) = @_;

    my $song_dir = $self->_title_to_dirname($root_dir);
    $self->_export_markdown($song_dir);
}

sub _title_to_dirname {
    my ($self, $root_dir) = @_;

    # Remove anything that's not A-za-z0-9,
    # Convert to Pascal case

    my $full_path = $root_dir . '/' . $self->_title_to_relative_dirname;

    mkpath($full_path, { mode => 0775 });
    return $full_path;
}

sub _title_to_relative_dirname {
    my ($self) = @_;

    # Remove anything that's not A-za-z0-9,
    # Convert to Pascal case

    return join('', map {
            $self->_convert_word($_)
        } split(/\s+/, $self->title)
    );
}

sub _convert_word {
    my ($self, $word) = @_;

    $word =~ s/[^0-9A-Za-z]//g;
    return ucfirst($word);
}

sub _export_markdown {
    my ($self, $song_dir) = @_;

    $self->_export_markdown_file($song_dir, 'summary', $self->summary_markdown);
    $self->_export_markdown_file($song_dir, 'article', $self->full_markdown);
    $self->_export_swift($song_dir);
}

sub _export_markdown_file {
    my ($self, $song_dir, $file, $md) = @_;

    # Old format: ^^somecode^^
    # New format: ^link(somecode)
    $md =~ s/\^\^(.*?)\^\^/^link($1)/g;

    my $full_file = "${song_dir}/${file}.md";
    my $fh = IO::File->new($full_file, ">:utf8");
    $fh->print($md, "\n") or die;
    $fh->close;
}

# Move this to a mixin role or something, it's a lotta shiz
# messing up the model class
sub _export_swift {
    my ($self, $song_dir) = @_;

    my $file = $self->_title_to_relative_dirname;

    my $full_file = "${song_dir}/${file}.swift";
    my $fh = IO::File->new($full_file, ">:utf8");
    $fh->print($self->_to_swift) or die;
    $fh->close;
}

sub _to_swift {
    my ($self) = @_;

    my $songFunc = lcfirst $self->_title_to_relative_dirname;
    my $tags     = $self->_convert_tags;

    my $timestamp = $self->created_at->set_time_zone("Europe/London")->epoch;

    my $pattern = <<"EOF";
extension Song {
    static func %s() -> Song {
        Song (
            id:        %d,
            style:     .listing,
            dir:       String.folderFromFunctionName(name: #function),
            artist:    "%s",
            title:     "%s",
            album:     "%s",
            released:  "%s",
            maxRez:    %d,
            createdAt: Date(timeIntervalSince1970: %d),
            updatedAt: Date(timeIntervalSince1970: %d),
            tags:      [%s],
            country:   ["%s"],
            links:     SongLinks(links: [
%s
            ])
        )
    }
}
EOF
    return sprintf($pattern,
        $songFunc,
        $self->id,
        $self->artist,
        $self->title,
        $self->album,
        $self->released_at,
        $self->max_resolution,
        $timestamp,
        $timestamp,
        $self->_convert_tags,
        $self->country,
        $self->_convert_links,
    );
}

sub _convert_tags {
    my ($self) = @_;

    return join(', ', map {
            $self->_convert_tag($_)
        } $self->tags->by_name->all
    );
}

sub _convert_tag {
    my ($self, $tag) = @_;

    my $name = join('', map {
            $self->_convert_word($_)
        } split(/\s+/, $tag->name)
    );

    return '.' . lcfirst($name);
}

sub _convert_links {
    my ($self) = @_;

    my @links = $self->links->search(undef, {
        order_by => 'id'
    })->all;

    return '' unless scalar @links;
    return join(",\n", map { $self->_convert_link($_)}  @links);
}

sub _convert_link {
    my ($self, $link) = @_;

    my @links;

    my $link_pattern = <<'EOF';
                SongLink(
                    id:        "%s",
                    embedText: "%s",
                    listText:  "%s",
                    linkType:  .youtubeLink(code: "%s")
                )
EOF
    chomp $link_pattern;

    push @links, sprintf(
        $link_pattern,
        $link->embed_identifier,
        $link->embed_description,
        $link->list_description,
        $link->list_url
    );

    return @links;
}

no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;
