package NeverTire::Util::Password;
use strict;
use warnings;

use Sub::Exporter -setup => {
    exports => [qw/
        new_password_hash
        check_password_hash
        random_user_key
        message_digest
    /],
};

use feature 'state';

use Authen::Passphrase::BlowfishCrypt;

# Trivial wrapper to the above, encapsulating our default
# Eksblowfish cost, etc.

sub new_password_hash {
    my ($password) = @_;

    # 13 is a decent bet for production in 2019
    # TODO Put this in app config.
    # TODO If it changes, automatically upgrade hashes on login.
    my $default_cost = $ENV{TEST_BCRYPT_COST} // 13;

    my $ppr = Authen::Passphrase::BlowfishCrypt->new(
        cost => $default_cost,
        salt_random => 1,
        passphrase => $password,
    );

    return $ppr->as_crypt;
}

sub check_password_hash {
    my ($password, $password_hash) = @_;

    my $ppr = Authen::Passphrase::BlowfishCrypt->from_crypt($password_hash);
    return $ppr->match($password);
}

# A random alphanumeric string is good enough for this
sub random_user_key {
    state $charset = ["A" .. "Z", "a" .. "z", "0" .. "9"];
    state $charcnt = scalar @$charset;

    # TODO make it congif, not hard-coded at 16 chars
    my $s;
    foreach my $i ( 1 .. 16 ) {
        $s .= $charset->[int(rand $charcnt)];
    }

    return $s;
}

# Simple digest for messages. Not intended to be crypto-quality,
# it's just to make searching for dupe content easier.
# SHA3 should be comfortably good enough.  Probs.
use Encode;
use Digest::SHA3 qw/ sha3_256_base64 /;

sub message_digest {
    my ($subject, $raw) = @_;

    return sha3_256_base64(encode("UTF-8", $subject . $raw));
}

1;
