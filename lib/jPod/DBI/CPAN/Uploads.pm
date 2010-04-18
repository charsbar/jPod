package jPod::DBI::CPAN::Uploads;

use strict;
use warnings;
use base qw/jPod::DBI/;
use jPod::CPAN::Dist;

sub table  { 'uploads' }

sub columns {(
    type     => 'text',
    author   => 'text',
    dist     => 'text',
    version  => 'text',
    filename => 'text',
    released => 'int',
)}

sub look_for {
    my ($self, $dist, $version, $type) = @_;

    my $where = 'where dist = ?';
    my @bind_values = $dist;
    if ( $version ) {
        $where .= ' and version = ?';
        push @bind_values, $version;
    }
    if ( $type ) {
        $where .= ' type = ?';
        push @bind_values, $type;
    }
    $where .= 'order by released desc limit 1';

    my $found = $self->select( $where, @bind_values ) or return;

    my $author = $found->{author};
    my $path   = join '/', substr($author, 0, 1),
                           substr($author, 0, 2),
                           $author, $found->{filename};

    return jPod::CPAN::Dist->new($path, $found->{type});
}

1;

__END__

=head1 NAME

jPod::DBI::CPAN::Uploads

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
