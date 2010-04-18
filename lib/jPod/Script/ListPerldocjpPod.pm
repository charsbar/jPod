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

    my %found = $perldocjp->find_pods;

    foreach my $package (sort keys %found) {
        foreach my $version (sort keys %{ $found{$package} }) {
            print "$package $version $found{$package}{$version}\n";
        }
    }
}

1;

__END__

=head1 NAME

jPod::Script::ListPerldocjpPod

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
