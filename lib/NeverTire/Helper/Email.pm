package NeverTire::Helper::Email;
use Mojo::Base 'Mojolicious::Plugin';

# TODO POD docs

use DateTime::Duration;
sub register {
    my ($self, $app, $conf) = @_;

    $app->helper(send_email => sub {
        my ($c, $template_name, $data) = @_;

        # Keeping a DB record of emails for test etc.
        my $email_rs = $c->schema->resultset('Email');
        my $email = $email_rs->create({
            email_from    => 'mailgun@blog.ytfc.com', # TODO Make configurable
            email_to      => lc($data->{to}),
            template_name => $template_name,
            data          => $data,
            queued_at     => DateTime->now,
        });

        # TODO queue minion job to send
    });

	$app->helper(send_registration_email => sub {
		my ($c, $user) = @_;

        my $duration = DateTime::Duration->new(hours => 1); # TODO Configurable
        my $user_key = $user->generate_new_user_key('registration', $duration);

        $c->send_email(registration => {
            to   => lc($user->email),
            user => $user->id,
            key  => $user_key,
        });
	});

	$app->helper(send_name_reminder => sub {
		my ($c, $user) = @_;

        $c->send_email(name_reminder => {
            to   => lc($user->email),
            user => $user->id,
            name => $user->name,
        });
	});

	$app->helper(send_password_reset => sub {
		my ($c, $user) = @_;
    
        my $duration = DateTime::Duration->new(hours => 1); # TODO Configurable
        my $user_key = $user->generate_new_user_key('password_reset', $duration);

        $c->send_email(password_reset => {
            to   => lc($user->email),
            user => $user->id,
            key  => $user_key,
        });
	});

}

1;
__END__

# TODO pod docs
