package NeverTire::Form::Song::Delete;
use Moose;
use namespace::autoclean;

use NeverTire::Form::Moose;
extends 'NeverTire::Form::Base';
with 'NeverTire::Form::Role';

has '+submit_label' => (default => 'Submit');
has '+id'           => (default => 'delete-song');

has song => (
    is          => 'ro',
    isa         => 'NeverTire::Schema::Result::Song',
    required    => 1,
);

has_field action => (
    type        => 'RadioButtonGroup',
    selections => [
        { value => 0, text => 'Do nothing', checked => 1, },
        { value => 1, text => 'Hide from public, but leave in DB' },
        { value => 2, text => 'Remove from DB' },
    ],
);


override posted => sub {
	my $self = shift;
	
    my $fields = $self->form_hash(qw/ action /);
    my $action = $fields->{action};

    my $song = $self->song;
    if ($action == 1) {
        $song->hide;
        return 'Song hidden';
    }
    elsif ($action == 2) {
        $song->delete;
        return 'Song deleted';
    }

    return 'No action taken';
};

__PACKAGE__->meta->make_immutable;
1;
