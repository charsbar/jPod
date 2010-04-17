use strict;
use warnings;
use Test::More;
use Path::Extended;
use Test::jPod::Script 'Setup';

test {
    my ($command, $context, $testdir) = @_;

    ok $context->home->exists, "home exists: ". $context->home;

    $command->_run($context);

    for my $dir ($context->directories) {
        ok $context->$dir->exists, "$dir exists: ".$context->$dir;
    }
};

done_testing;
