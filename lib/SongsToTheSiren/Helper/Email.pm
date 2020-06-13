package SongsToTheSiren::Helper::Email;
use Mojo::Base 'Mojolicious::Plugin';

# POD docs at end of file

use DateTime::Duration;

sub register {
    my ($self, $app, $conf) = @_;

    $app->helper(
        send_email => sub {
            my ($c, $template_name, $data) = @_;

            # Keeping a DB record of emails for test etc.
            my $email_rs = $c->schema->resultset('Email');
            my $to       = lc($data->{to});

            my $email
                = $email_rs->create({
                email_to => $to, template_name => $template_name, data => $data, queued_at => DateTime->now,
                });

            if ($app->mode ne 'test') {
                $app->minion->enqueue(smtp => [$email->id]);

                # TODO Start a daemon rather than this:
                $app->minion->perform_jobs;
            }
        }
    );

    $app->helper(
        send_registration_email => sub {
            my ($c, $user) = @_;

            my $duration = DateTime::Duration->new(hours => 1);                       # TODO Configurable
            my $user_key = $user->generate_new_user_key('registration', $duration);

            $c->send_email(registration => {to => lc($user->email), user => $user->id, key => $user_key,});
        }
    );

    $app->helper(
        send_name_reminder => sub {
            my ($c, $user) = @_;

            $c->send_email(name_reminder => {to => lc($user->email), user => $user->id, name => $user->name,});
        }
    );

    $app->helper(
        send_password_reset => sub {
            my ($c, $user) = @_;

            my $duration = DateTime::Duration->new(hours => 1);                         # TODO Configurable
            my $user_key = $user->generate_new_user_key('password_reset', $duration);

            $c->send_email(password_reset => {to => lc($user->email), user => $user->id, key => $user_key,});
        }
    );

    $app->helper(
        send_comment_notification => sub {
            my ($c, $comment) = @_;

            # Send to each admin user
            my $rs             = $c->schema->resultset('User');
            my $admin_users_rs = $rs->admin_users;

            while (my $user = $admin_users_rs->next) {
                $c->send_email(comment_notification =>
                        {to => lc($user->email), song_title => $comment->song->title, song_id => $comment->song->id,});
            }
        }
    );

}

1;
__END__

=pod

=head1 NAME

SongsToTheSiren::Helper::Email : Helpers for sending emails from blog app

=head1 SYNOPSIS

    # In app startup()
    $self->plugin('SongsToTheSiren::Helper::Email');

    # In your controller actions:
    $app->send_registration_email($user);
    $app->send_name_reminder($user);
    $app->send_password_reset($user);
    $app->send_comment_notification($comment);

=head1 DESCRIPTION

Provides helper methods for sending emails.  Saves the email in the
database ('emails' table), then builds the mail from a template
and uses Net::SMTP::TLS to send it

=head1 HELPERS

=over

=item send_registration_email($user)

Sends the initial mail that a new user gets when registering.

Templates are in templates/email/registration

$user is a L<SongsToTheSiren::Schema::Result::User> object.


=item send_name_reminder($user)

Sends the mail reminding someone of their login username if
they forgot. 

Templates are in templates/email/name_reminder

$user is a L<SongsToTheSiren::Schema::Result::User> object.


=item send_password_reset($user)

Sends a mail allowing a user to reset their password, e.g.
if they forgot it.

Templates are in templates/email/password_reset

$user is a L<SongsToTheSiren::Schema::Result::User> object.

=back

=head1 AUTHOR

David Stevenson david@ytfc.com
