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


no Moose::Role;

1;
