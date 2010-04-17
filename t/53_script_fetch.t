use strict;
use warnings;
use Test::More;
use Test::jPod::Script 'Fetch';
use Path::Extended;

test {
    my ($command, $context, $testdir) = @_;

    my $private_db = file('.jpod/uploads.db');

    unless ($ENV{RELEASE_TESTING} or !$private_db->exists) {
        note "skipped tests";
        return;
    }

    $context->setup;

    my $dbfile = $context->private->file('uploads.db');
    $private_db->copy_to( $dbfile );

    ok $dbfile->exists, "database exists";

    $command->_run($context, 'Moose', '1.00');
    my $tarball = $context->src->file('Moose/Moose-1.00.tar.gz');
    ok $tarball->exists, "Moose 1.00 tarball exists";
};

done_testing;
