package NeverTire::Form::Meta::Form;

use Moose::Role;

has form_fields => (
    traits      => ['Array'],
    is			=> 'rw',
    isa			=> 'ArrayRef[NeverTire::Form::Field]',
    default		=> sub{ [] },
    handles     => {
        add_field => 'push',
    },
);

has form_buttons => (
    traits      => ['Array'],
    is			=> 'rw',
    isa			=> 'ArrayRef[NeverTire::Form::Button]',
    default		=> sub{ [] },
    handles     => {
        add_button => 'push',
    },
);


no Moose::Role;

1;
