package NeverTire::Schema::Role::User::Page;
use Moose::Role;

# TODO Add pod

use DateTime;
use Text::Markdown qw/ markdown /;
use Carp qw/ croak /;

use Readonly;

Readonly my $NOT_ADMIN => 'Not admin - permission denied';

# This exists just to keep Result::User down to a more managable size.
# It extracts the methods relating to pages etc

sub admin_create_page {
    my ($self, $args) = @_;

    croak $NOT_ADMIN unless $self->admin;

    my $full_args = {
        %$args,
        html       => markdown($args->{markdown}),
        updated_at => DateTime->now,
    };

    return $self->create_related('pages', $full_args);
}

sub admin_edit_page {
    my ($self, $page, $args) = @_;

    croak $NOT_ADMIN unless $self->admin;

    my $full_args = {
        %$args,
        html       => markdown($args->{markdown}),
        updated_at => DateTime->now,
    };

    # TODO Record who did the update
    $page->update($full_args);
    
    return $page;
}


no Moose::Role;
1;

