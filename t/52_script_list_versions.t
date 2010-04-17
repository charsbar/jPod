use strict;
use warnings;
use Test::More;
use Test::jPod::Script 'ListVersions';
use Path::Extended;
use Capture::Tiny qw/capture/;

test {
    my ($command, $context, $testdir) = @_;

    my $private_db = file('.jpod/uploads.db');

    unless ($private_db->exists) {
        note "skipped tests";
        return;
    }

    $context->setup;

    my $dbfile = $context->private->file('uploads.db');
    $private_db->copy_to( $dbfile );

    ok $dbfile->exists, "database exists";

    my $captured = capture { $command->_run($context, 'Moose') };

    like $captured => qr/^Moose\s+[\d._]+\s+[\d\-]+\s+(?:cpan|backpan)\s+[A-Z]+/, "captured looks correct";
};

done_testing;
