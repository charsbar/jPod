package jPod::Script::ExtractPerldocjpSource;

use strict;
use warnings;
use base qw/jPod::Command/;
use jPod::Archive;

sub _run {
    my ($self, $context, @args) = @_;

    my $tarball = $context->private->file('perldocjp.tar.gz');

    unless ( $tarball->exists ) {
        my $error = "$tarball not found";
        $self->log( fatal => $error );
        croak $error;
    }

    my $archive = jPod::Archive->new(
        archive => $tarball,
        verbose => $self->{verbose},
    );

    my $dir = $context->private->subdir('perldocjp');
    $archive->extract( to => $dir, pod_only => 1 );
    $self->log( info => "extracted perldocjp source successfully" );
}

1;

__END__

=head1 NAME

jPod::Script::ExtractPerldocjpSource - extract perldoc.jp tarball

=head1 SYNOPSIS

  > jpod extract_perldocjp_source

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
