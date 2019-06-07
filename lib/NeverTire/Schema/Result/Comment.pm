package NeverTire::Schema::Result::Comment;
use Moose;
use namespace::autoclean;

extends 'NeverTire::Schema::Base::Result';

# TODO POD

use DateTime;

__PACKAGE__->load_components('InflateColumn::DateTime');

__PACKAGE__->table('comments');

__PACKAGE__->add_columns(
    id               => {data_type => 'INTEGER'},
    song_id          => {data_type => 'INTEGER'},
    author_id        => {data_type => 'INTEGER'},
    
    parent_id        => {data_type => 'INTEGER'},

    comment_markdown => {data_type => 'TEXT'},
    comment_html     => {data_type => 'TEXT'},

    created_at       => {data_type => 'DATETIME'},
    approved_at      => {data_type => 'DATETIME'},
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(author => 'NeverTire::Schema::Result::User',    { 'foreign.id' => 'self.author_id' });

__PACKAGE__->belongs_to(parent => 'NeverTire::Schema::Result::Comment', { 'foreign.id' => 'self.parent_id' });
__PACKAGE__->has_many(replies  => 'NeverTire::Schema::Result::Comment', { 'foreign.parent_id' => 'self.id' });

__PACKAGE__->belongs_to(song   => 'NeverTire::Schema::Result::Song',    { 'foreign.id' => 'self.song_id' });

no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;
