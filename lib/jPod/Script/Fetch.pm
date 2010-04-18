package jPod::Script::Fetch;

use strict;
use warnings;
use Carp;
use base qw/jPod::Command/;
use jPod::DBI::CPAN::Uploads;
use jPod::UserAgent;

sub _run {
    my ($self, $context, $dist, $version, @args) = @_;

    my $dbfile = $context->private->file('uploads.db');

    my $db = jPod::DBI::CPAN::Uploads->new( $dbfile );

    my $found = $db->look_for($dist, $version, @args);

    unless ($found) {
        my $error = "$dist is not found in the cpan/backpan";
        $self->log( fatal => $error );
        croak $error;
    }

    my $distdir = $context->src->subdir( $found->name );
    unless ( $distdir->exists ) {
        $self->log( info => "created $distdir" );
        $distdir->mkdir;
    }

    my $ua = jPod::UserAgent->new( verbose => $self->{verbose} );

    my $archive = $distdir->file( $found->basename );
    $ua->mirror( $found->url => $archive ) or return;

    my $distv = $found->distv;
    $self->log( info => "fetched $distv successfully" );
}

1;

__END__

=head1 NAME

jPod::Script::Fetch - fetch a distribution from cpan/backpan

=head1 SYNOPSIS

  > perl jpod fetch Moose
  > perl jpod fetch Moose 1.00

=head1 DESCRIPTION

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
