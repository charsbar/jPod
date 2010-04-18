package jPod::Script::ListVersions;

use strict;
use warnings;
use base qw/jPod::Command/;
use jPod::DBI::CPAN::Uploads;
use Time::Piece;

sub _run {
    my ($self, $context, $dist, $version) = @_;

    my $dbfile = $context->private->file('uploads.db');

    my $db = jPod::DBI::CPAN::Uploads->new( $dbfile );

    my @founds = $db->select_all('where dist = ? order by released', $dist);

    foreach my $found (@founds) {
        if ($version) {
           next unless $found->{version} =~ /^$version/;
        }
        printf "%s  %10s  %s  %7s  %9s\n",
           $found->{dist},
           $found->{version},
           localtime($found->{released})->ymd,
           $found->{type},
           $found->{author};
    }
}

1;

__END__

=head1 NAME

jPod::Script::ListVersions - list version history of a distribution

=head1 SYNOPSIS

  jpod list_versions Moose

=head1 DESCRIPTION

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
