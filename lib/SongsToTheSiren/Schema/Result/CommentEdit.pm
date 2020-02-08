package SongsToTheSiren::Schema::Result::CommentEdit;
use Moose;
use namespace::autoclean;

extends 'SongsToTheSiren::Schema::Base::Result';

# TODO POD

use DateTime;

__PACKAGE__->load_components('InflateColumn::DateTime');

__PACKAGE__->table('comment_edits');

__PACKAGE__->add_columns(
    id               => {data_type => 'INTEGER'},
    comment_id       => {data_type => 'INTEGER'},
    reason           => {data_type => 'TEXT'},

    editor_id        => {data_type => 'INTEGER'},
    edited_at        => {data_type => 'DATETIME'},
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(comment => 'SongsToTheSiren::Schema::Result::Comment', { 'foreign.id' => 'self.comment_id' });
__PACKAGE__->belongs_to(editor  => 'SongsToTheSiren::Schema::Result::User',    { 'foreign.id' => 'self.editor_id' });

no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;
