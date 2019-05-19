package NeverTire::Test;
use Moose;
use namespace::autoclean;

use Class::Load;

sub run {
    my ($self, $sub_package) = @_;
    
    my $pkg = 'NeverTire::Test::' . $sub_package;
    Class::Load::load_class($pkg);
    my $tester = $pkg->new;
    $tester->run;
}

__PACKAGE__->meta->make_immutable;
1;
