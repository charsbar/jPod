package jPod::Archive::Bzip2;

use strict;
use warnings;
use jPod::Log;
use IO::Uncompress::Bunzip2 qw/bunzip2 $Bunzip2Error/;

sub new {
    my ($class, %args) = @_;

    bless \%args, $class;
}

sub extract {
    my ($self, %args) = @_;

    # Stringify as IO::Uncompress::Bunzip2 doesn't like objects
    my $archive = "$self->{archive}";
    my $file    = "$args{to}";
    $self->log( info => "extracting $archive to $file" );

    bunzip2 "$archive" => "$file", BinModeOut => 1 or do {
        $self->log( fatal => $Bunzip2Error );
        return;
    }
}

1;

__END__

=head1 NAME

jPod::Archive::Bzip2

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
