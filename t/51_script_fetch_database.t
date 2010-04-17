use strict;
use warnings;
use Test::More;
use Test::jPod::Script 'FetchDatabase';
use Path::Extended;

test {
    my ($command, $context, $testdir) = @_;

    my $private_db = file('.jpod/uploads.db');

    unless ($ENV{RELEASE_TESTING} or !$private_db->exists) {
        note "skipped tests";
        return;
    }

    $context->setup;

    $command->_run($context);

    my $dbfile = $context->private->file('uploads.db');
    ok $dbfile->exists, "upload.db exists";

    $dbfile->copy_to( $private_db );
    ok $private_db->exists, "copied database";
};

done_testing;
