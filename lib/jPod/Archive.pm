package jPod::Archive;

use strict;
use warnings;

sub new {
    my ($class, %args) = @_;

    bless \%args, $class;
}

sub extract {
    my ($self, %args) = @_;

    my $archive = $self->{archive} || delete $args{archive};

    my $class;
    if ( $archive =~ /\.tar\.gz$/ ) {
        $class = 'jPod::Archive::Tar';
    }
    elsif ( $archive =~ /\.zip$/ ) {
        $class = 'jPod::Archive::Zip';
    }
    elsif ( $archive =~ /\.gz$/ ) {
        $class = 'jPod::Archive::Gzip';
    }
    elsif ( $archive =~ /\.bz2$/ ) {
        $class = 'jPod::Archive::Bzip2';
    }
    eval "require $class";
    $class->new( archive => $archive, verbose => $self->{verbose} )
          ->extract(%args);
}

1;

__END__

=head1 NAME

jPod::Archive

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
