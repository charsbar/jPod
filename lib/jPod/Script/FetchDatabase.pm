package jPod::Script::FetchDatabase;

use strict;
use warnings;
use base qw/jPod::Command/;
use jPod::UserAgent;
use Archive::Extract;

my $url = 'http://devel.cpantesters.org/uploads/uploads.db.bz2';

sub _run {
    my ($self, $context, @args) = @_;

    my $bzipfile = $context->private->file('uploads.db.bz2');
    my $dbfile   = $context->private->file('uploads.db');

    if ( !$self->{force}
      and $dbfile->exists
      and $dbfile->mtime > time - 60 * 60 * 24) {
        $self->log( info => "database is fresh enough" );
        return;
    }

    my $ua = jPod::UserAgent->new( verbose => $self->{verbose} );
    $ua->mirror( $url => $bzipfile ) or return;

    my $archive = Archive::Extract->new( archive => $bzipfile );
    $archive->extract( to => $dbfile );

    $self->log( info => "updated database successfully" );
}

1;

__END__

=head1 NAME

jPod::Script::FetchDatabase - fetch uploads.db from cpantesters

=head1 SYNOPSIS

  > perl jpod fetch_database

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
