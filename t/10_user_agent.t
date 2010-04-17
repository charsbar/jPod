use strict;
use warnings;
use Test::More;
use Test::TCP;
use jPod::UserAgent;
use Path::Extended;
use Plack::Handler::Standalone;

my $ua = jPod::UserAgent->new( verbose => $ENV{TEST_VERBOSE} );

test_tcp(
    client => sub {
        my $port = shift;
        my $url  = "http://localhost:$port";

        my $testdir = dir('test')->mkdir;
        ok $testdir->exists, "created test directory";

        my $file = $testdir->file('test.txt');
        ok !$file->exists, "$file not exists";

        my $res = eval { $ua->mirror( $url => $file ) };
        ok !$@ && $res, "mirrored successfully";

        ok $file->exists, "$file exists";
        is $file->slurp => "ok", "$file contains correct string";

        $testdir->remove;
        ok !$testdir->exists, "removed test directory";
    },
    server => sub {
        my $port = shift;
        Plack::Handler::Standalone
            ->new(port => $port)
            ->run(sub { return [
                200,
                [ 'Content-Type' => 'text/plain' ],
                [ "ok" ],
            ]});
    },
);

done_testing;
