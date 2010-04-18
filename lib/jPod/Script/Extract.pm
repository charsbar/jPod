package jPod::Script::Extract;

use strict;
use warnings;
use Carp;
use base qw/jPod::Command/;
use jPod::CPAN::Uploads;
use jPod::Archive;

sub options { qw/ pod_only|pod / }

sub _run {
    my ($self, $context, @args) = @_;

    exit !!$self->usage unless @args;

    my $dbfile = $context->private->file('uploads.db');

    my $db = jPod::CPAN::Uploads->new( $dbfile );

    my $found = $db->look_for(@args);

    unless ($found) {
        my $error = "$args[0] is not found in the cpan/backpan";
        $self->log( fatal => $error );
        croak $error;
    }

    my $distdir = $context->src->subdir( $found->name );
    my $file    = $distdir->file( $found->basename );
    my $distv   = $found->distv;

    unless ($file->exists) {
        my $error = "$file is not found";
        $self->log( fatal => $error );
        croak $error;
    }

    my $archive = jPod::Archive->new(
        archive => $file,
        verbose => $self->{verbose},
    );

    $archive->extract(
        to       => $distdir->subdir( $distv ),
        pod_only => 1,
    );

    $self->log( info => "extracted $distv successfully" );
}

1;

__END__

=head1 NAME

jPod::Script::Extract - extract a source distribution

=head1 SYNOPSIS

  > jpod extract Moose 1.00

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
