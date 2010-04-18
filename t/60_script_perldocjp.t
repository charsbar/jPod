use strict;
use warnings;
use Test::More;
use Path::Extended;
use Capture::Tiny qw/capture/;
use Test::jPod::Script qw/
    Setup
    FetchPerldocjpSource
/;

setup {
    my ($command, $context, $testdir) = @_;

    ok $context->home->exists, "home exists: ". $context->home;

    $command->_run($context);

    for my $dir ($context->directories) {
        ok $context->$dir->exists, "$dir exists: ".$context->$dir;
    }
};

fetch_perldocjp_source {
    my ($command, $context, $testdir) = @_;

    my $private = file('.jpod/perldocjp.tar.gz');
    my $tarball = $context->private->file('perldocjp.tar.gz');

    unless ($ENV{RELEASE_TESTING} or !$private->exists) {
        $private->copy_to($tarball) if $private->exists;
        note "skipped tests";
        return;
    }

    $command->_run($context);

    ok $tarball->exists, "perldocjp.tar.gz exists";

    $tarball->copy_to( $private );
    ok $private->exists, "copied tarball";
};

done_testing;