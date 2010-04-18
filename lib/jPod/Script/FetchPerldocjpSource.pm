package jPod::Script::FetchPerldocjpSource;

use strict;
use warnings;
use base qw/jPod::Command/;
use jPod::UserAgent;

my $url = 'http://sourceforge.jp/cvs/view/perldocjp.tar.gz';

sub _run {
    my ($self, $context, @args) = @_;

    my $tarball = $context->private->file('perldocjp.tar.gz');

    if ( !$self->{force}
      and $tarball->exists
      and $tarball->mtime > time - 60 * 60 * 24) {
        $self->log( info => "tarball is fresh enough" );
        return;
    }

    my $ua = jPod::UserAgent->new( verbose => $self->{verbose} );
    $ua->mirror( $url => $tarball ) or return;

    $self->log( info => "downloaded tarball successfully" );
}

1;

__END__

=head1 NAME

jPod::Script::FetchPerldocjpSource - fetch perldoc.jp tarball from sourceforge

=head1 SYNOPSIS

  > jpod fetch_perldocjp_source

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
