use strict;
use warnings;
use inc::Module::Install;

all_from 'lib/jPod.pm';

requires 'CLI::Dispatch' => 0.07;  # usage
requires 'DBD::SQLite' => 1.30_02; # sqlite_use_immediate_transaction
requires 'DBI'         => 1.609;
requires 'File::HomeDir';
requires 'IO::Uncompress::Bunzip2';
requires 'Log::Dump::Class';
requires 'LWP::UserAgent';
requires 'Path::Extended';
requires 'Sub::Install';

test_requires 'Capture::Tiny';
test_requires 'Plack::Handler::Standalone';
test_requires 'Test::More' => 0.88;  # done_testing
test_requires 'Test::TCP';
test_requires 'Test::UseAllModules';

install_script 'jpod';

WriteAll;
