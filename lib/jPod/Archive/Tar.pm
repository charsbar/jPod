package jPod::Archive::Tar;

use strict;
use warnings;
use Carp;
use Archive::Tar;
use jPod::Log;
use Path::Extended;

sub new {
    my ($class, %args) = @_;

    bless \%args, $class;
}

sub extract {
    my ($self, %args) = @_;

    my $dir = dir($args{to})->mkdir;
    my $tar = Archive::Tar->new;

    my $archive = $self->{archive} || $args{archive};
    $tar->read("$archive") or croak $!;

    my $basename = $dir->basename;
    foreach my $file ( $tar->list_files ) {
        if ($args{pod_only}) {
            next unless $file =~ /\.(?:pod|pm)$/;
            next if     $file =~ /\b(?:inc|t)\b/;
        }

        $self->log( debug => "extracting $file") if $self->{verbose};

        my $content = $tar->get_content($file);

        if ($args{pod_only}) {
            $content =~ s/\015\012/\012/g;
        }

        $file =~ s/^$basename//;
        $file =~ s/^[\/\\]//;

        $dir->file($file)->save($content, mkdir => 1, binmode => 1);
    }
}

1;

__END__

=head1 NAME

jPod::Archive::Tar

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
