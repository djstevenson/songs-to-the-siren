package NeverTire::Schema::Role::User::Country;
use Moose::Role;

# TODO Add pod

use DateTime;
use Text::Markdown qw/ markdown /;
use Carp qw/ croak /;

use Readonly;

Readonly my $NOT_ADMIN => 'Not admin - permission denied';

# This exists just to keep Result::User down to a more managable size.
# It extracts the methods relating to country codes etc

sub admin_create_country {
    my ($self, $args) = @_;

    croak $NOT_ADMIN unless $self->admin;

    my $rs = $self->result_source->schema->resultset('Country');
    $rs->create($args);
}

sub admin_edit_country {
    my ($self, $country, $args) = @_;

    croak $NOT_ADMIN unless $self->admin;

    $country->update($args);
    
    return $country;
}


no Moose::Role;
1;

