use strict;
use warnings;
use Test::More;
use Path::Extended;

BEGIN {
    plan skip_all => "for release test" unless $ENV{RELEASE_TESTING};
}

use Test::jPod::Script 'FetchDatabase';

test {
    my ($command, $context, $testdir) = @_;

    $context->setup;

    $command->_run($context);

    ok $context->private->file('uploads.db')->exists, "upload.db exists";
};

done_testing;
