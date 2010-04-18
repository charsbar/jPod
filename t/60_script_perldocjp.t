use strict;
use warnings;
use Test::More;
use Path::Extended;
use Capture::Tiny qw/capture/;
use Test::jPod::Script qw/
    Setup
    FetchPerldocjpSource
    ExtractPerldocjpSource
    ListPerldocjpPod
    RegisterPerldocjpPod
    FindExternalTranslation
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

extract_perldocjp_source {
    my ($command, $context, $testdir) = @_;

    my $tarball = $context->private->file('perldocjp.tar.gz');

    $command->_run($context);

    my $dir = $context->private->subdir('perldocjp');
    ok $dir->exists, "perldocjp directory exists";
    ok $dir->subdir('docs')->exists, "perldocjp/docs directory exists";
};

list_perldocjp_pod {
    my ($command, $context, $testdir) = @_;

    my $captured = capture { $command->_run($context) };

    like $captured => qr/^\S+\s+\S+\s+\S+/, "captured looks correct";
};

register_perldocjp_pod {
    my ($command, $context, $testdir) = @_;

    my $dbfile = $context->private->file('external.db');
    ok !$dbfile->exists, "dbfile does not exist";

    $command->_run($context);

    ok $dbfile->exists, "dbfile exists";
};

find_external_translation {
    my ($command, $context, $testdir) = @_;

    my $captured = capture { $command->_run($context, 'perlvar') };

    chomp $captured;

    like $captured => qr{http://perldoc.jp/docs/perl/5.[\d.]+/perlvar.pod.pod}, "pod_url looks correct";
};

done_testing;
