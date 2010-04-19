package jPod::Script::ListPerldocjpPod;

use strict;
use warnings;
use base qw/jPod::Command/;
use jPod::ExternalSource::Perldocjp;

sub _run {
    my ($self, $context, @args) = @_;

    my $perldocjp = jPod::ExternalSource::Perldocjp->new(
        dir => $context->private->subdir('perldocjp'),
    );

    my @found = $perldocjp->find_pods;

    foreach my $entry (sort { $a->name cmp $b->name or $a->version <=> $b->version } @found) {
        printf "%s %s %s\n",
            $entry->name,
            $entry->version,
            $entry->path;
    }
}

1;

__END__

=head1 NAME

jPod::Script::ListPerldocjpPod - list of pods in perldoc.jp

=head1 SYNOPSIS

  > perl jpod list_perldocjp_pod

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
