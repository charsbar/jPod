package jPod::UserAgent;

use strict;
use warnings;
use Carp;
use LWP::UserAgent;
use jPod::Log;

sub new {
    my ($class, %args) = @_;

    my $ua = LWP::UserAgent->new(
        env_proxy     => 1,
        show_progress => $args{verbose},
    );
    bless { ua => $ua }, $class;
}

sub mirror {
    my ($self, $url, $file) = @_;

    $self->log( debug => "mirroring from $url" );

    my $response = $self->{ua}->mirror( $url => $file );
    unless ( $response->is_success ) {
        if ( $response->code == 304 ) {
           $self->log( info => "not modified" );
           return;
        }
        my $status = $response->status_line;
        my $error = "download failed: $status $url";
        $self->log( fatal => $error );
        croak $error;
    }
    return 1;
}

1;

__END__

=head1 NAME

jPod::UserAgent

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
