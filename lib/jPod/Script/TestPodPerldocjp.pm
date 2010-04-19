package jPod::Script::TestPodPerldocjp;

use strict;
use warnings;
use base qw/jPod::Command/;
use jPod::DBI::ExternalSources;

sub _run {
    my ($self, $context, @args) = @_;

    my $dbi = jPod::DBI::ExternalSources->new(
        $context->private->file('external.db')
    );

    my @founds = $dbi->select_all;
    foreach my $found (@founds) {
        system 'perldocjp', '-JT', $found->{name};
        if ($self->{verbose}) {
            print "Hit Return"; <STDIN>;
        }
    }
}

1;

__END__

=head1 NAME

jPod::Script::TestPodPerldocjp - test Pod::PerldocJp

=head1 SYNOPSIS

  > perl jpod test_pod_perldocjp

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
