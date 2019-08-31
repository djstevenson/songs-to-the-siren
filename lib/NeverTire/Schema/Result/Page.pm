package NeverTire::Schema::Result::Page;
use Moose;
use namespace::autoclean;

extends 'NeverTire::Schema::Base::Result';

# TODO POD

use DateTime;
use Text::Markdown qw/ markdown /;

__PACKAGE__->load_components('InflateColumn::DateTime');

__PACKAGE__->table('pages');

__PACKAGE__->add_columns(
    name             => {data_type => 'TEXT'},
    title            => {data_type => 'TEXT'},

    markdown         => {data_type => 'TEXT'},
    html             => {data_type => 'TEXT'},

    author_id        => {data_type => 'INTEGER'},
    
    updated_at       => {data_type => 'DATETIME'},
);

__PACKAGE__->set_primary_key('name');

no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;
