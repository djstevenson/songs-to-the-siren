package SongsToTheSiren::Helper::Form;
use Mojo::Base 'Mojolicious::Plugin';

# POD at end of source file

use SongsToTheSiren::Form::Factory;

sub register {
    my ($self, $app) = @_;

    $app->helper(
        form => sub {
            my ($c, $name, @args) = @_;
            state $form_factory = SongsToTheSiren::Form::Factory->new;
            return $form_factory->form($name, {c => $c, @args});
        }
    );

    return;
}

1;
__END__

=pod

=head1 NAME

SongsToTheSiren::Helper::Form : helper to instantiate form views

=head1 SYNOPSIS

    # In app startup()
    $self->plugin('SongsToTheSiren::Helper::Form');

    # To instantiate a form, e.g.
    my $form = $c->form('Topic::Create');
    $c->stash(form => $form);

=head1 DESCRIPTION

Provides a 'form' helper to create a form view

=head1 HELPERS

=over

=item form

    $c->form($some_partial_class_name);

Creates a form of type SongsToTheSiren::Form::$some_partial_class_name

=back

=head1 AUTHOR

David Stevenson david@ytfc.com

