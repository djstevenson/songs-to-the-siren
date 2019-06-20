package NeverTire::Form::Link::Delete;
use Moose;
use namespace::autoclean;

# TODO Be more consistent.  Link forms are 
# under NT::Form::Link but link tables are
# under NT::Table::Song::Link  - ie one
# includes Song in the chain and one doesn't.

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

use Readonly;
Readonly my $CANCEL => 0;
Readonly my $DELETE => 1;

has '+id'           => (default => 'delete-link');

has song => (
    is          => 'ro',
    isa         => 'NeverTire::Schema::Result::Song',
    required    => 1,
);

has link => (
    is          => 'ro',
    isa         => 'NeverTire::Schema::Result::Link',
    required    => 1,
);

has_field action => (
    type        => 'RadioButtonGroup',
    selections => [
        { value => $CANCEL, text => 'Do nothing', checked => 1, },
        { value => $DELETE, text => 'Delete link' },
    ],
);

has_button delete_link => ();

override posted => sub {
	my $self = shift;
	
    my $fields = $self->form_hash(qw/ action /);
    my $action = $fields->{action};

    if ($action == $DELETE) {
        $self->link->delete;
        return 'Song deleted';
    }

    return 'No action taken';
};

__PACKAGE__->meta->make_immutable;
1;
