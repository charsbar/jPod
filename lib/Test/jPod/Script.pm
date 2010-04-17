package Test::jPod::Script;

use strict;
use warnings;
use Test::More;
use jPod::Context;
use Path::Extended;
use Sub::Install 'install_sub';

sub import {
    my ($class, $target) = @_;

    my $package = "jPod::Script::$target";
    use_ok($package);

    install_sub({
        as   => 'test',
        into => caller,
        code => sub (&) {
            my $test = shift;

            my $testdir = dir('test')->mkdir;
            ok $testdir->exists, "created test directory";

            my $command = $package->new;
               $command->set_options(verbose => $ENV{TEST_VERBOSE});

            my $context = jPod::Context->new(home => $testdir);

            eval { $test->($command, $context, $testdir) };
            ok !$@, "test runs successfully";

            $testdir->remove;
            ok !$testdir->exists, "removed test directory";
        },
    });
}

1;

__END__

=head1 NAME

Test::jPod::Script

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 new

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
