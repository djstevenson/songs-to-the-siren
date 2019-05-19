package NeverTire::Form::Field::Validator::ValidEmail;
use namespace::autoclean;
use Moose;

extends 'NeverTire::Form::Field::Validator::Base';
with 'NeverTire::Form::Field::Validator::Role';


sub validate{
	my ($self, $value) = @_;

    return undef if $value =~ m{^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$}i;

    return 'Invalid email address';

}


__PACKAGE__->meta->make_immutable;
1;
