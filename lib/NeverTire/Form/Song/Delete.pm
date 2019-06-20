package NeverTire::Form::Song::Delete;
use Moose;
use namespace::autoclean;

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

use Readonly;
Readonly my $CANCEL => 0;
Readonly my $HIDE   => 1;
Readonly my $DELETE => 2;

has '+id' => (default => 'delete-song');

has song => (
    is          => 'ro',
    isa         => 'NeverTire::Schema::Result::Song',
    required    => 1,
);

has_field action => (
    type        => 'RadioButtonGroup',
    selections => [
        { value => $CANCEL, text => 'Do nothing', checked => 1, },
        { value => $HIDE,   text => 'Hide from public, but leave in DB' },
        { value => $DELETE, text => 'Remove from DB' },
    ],
);


override posted => sub {
	my $self = shift;
	
    my $fields = $self->form_hash(qw/ action /);
    my $action = $fields->{action};

    my $song = $self->song;
    if ($action == $HIDE) {
        $song->hide;
        return 'Song hidden';
    }
    elsif ($action == $DELETE) {
        $song->delete;
        return 'Song deleted';
    }

    return 'No action taken';
};

__PACKAGE__->meta->make_immutable;
1;
