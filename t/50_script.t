use strict;
use warnings;
use Test::More;
use Path::Extended;
use Capture::Tiny qw/capture/;
use Test::jPod::Script qw/
    Setup
    FetchDatabase
    ListVersions
    Fetch
    Extract
/;

setup {
    my ($command, $context, $testdir) = @_;

    ok $context->home->exists, "home exists: ". $context->home;

    $command->_run($context);

    for my $dir ($context->directories) {
        ok $context->$dir->exists, "$dir exists: ".$context->$dir;
    }
};

fetch_database {
    my ($command, $context, $testdir) = @_;

    my $private_db = file('.jpod/uploads.db');
    my $dbfile     = $context->private->file('uploads.db');

    unless ($ENV{RELEASE_TESTING} or !$private_db->exists) {
        $private_db->copy_to($dbfile) if $private_db->exists;
        note "skipped tests";
        return;
    }

    $context->setup;

    $command->_run($context);

    ok $dbfile->exists, "upload.db exists";

    $dbfile->copy_to( $private_db );
    ok $private_db->exists, "copied database";
};

list_versions {
    my ($command, $context, $testdir) = @_;

    my $dbfile = $context->private->file('uploads.db');
    ok $dbfile->exists, "database exists";

    my $captured = capture { $command->_run($context, 'Moose') };

    like $captured => qr/^Moose\s+[\d._]+\s+[\d\-]+\s+(?:cpan|backpan)\s+[A-Z]+/, "captured looks correct";
};

fetch {
    my ($command, $context, $testdir) = @_;

    my $dbfile = $context->private->file('uploads.db');
    ok $dbfile->exists, "database exists";

    $command->_run($context, 'Moose', '1.00');
    my $tarball = $context->src->file('Moose/Moose-1.00.tar.gz');
    ok $tarball->exists, "Moose 1.00 tarball exists";
};

extract {
    my ($command, $context, $testdir) = @_;

    my $dbfile = $context->private->file('uploads.db');
    ok $dbfile->exists, "database exists";

    $command->_run($context, 'Moose', '1.00');
    my $dir = $context->src->subdir('Moose/Moose-1.00/');
    ok $dir->exists, "Moose 1.00 directory exists";

    ok $dir->file('lib/Moose.pm')->exists, "Moose.pm exists";
    ok !$dir->file('Makefile.PL')->exists, "Makefile.PL is skipped";
};

done_testing;
