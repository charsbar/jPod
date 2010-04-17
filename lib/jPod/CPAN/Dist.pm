package jPod::CPAN::Dist;

use strict;
use warnings;

sub new {
    my ($class, $path, $type) = @_;

    $type ||= 'cpan';

    bless { path => $path, type => $type }, $class;
}

sub path { shift->{path} }

sub basename {
    my $self = shift;

    my ($basename) = $self->path =~ m{/([^/]+)$};
    return $basename;
}

sub cpan_path {
    my $self = shift;
    return "authors/id/".$self->path;
}

sub distv {
    my $self = shift;

    my $distv = $self->basename;
    $distv =~ s/\.(?:zip|tar\.gz)$//;
    return $distv;
}

sub name {
    my $self = shift;

    my $name = $self->distv;
    $name =~ s/\-v?[\d_\.]{3,}[a-z]*$//;
    return $name;
}

sub dir {
    my $self = shift;

    return join '/', $self->name, $self->distv;
}

sub url {
    my $self = shift;

    my $subdomain = $self->{type} eq 'cpan' ? 'www' : 'backpan';

    return "http://$subdomain.cpan.org/" . $self->cpan_path;
}

1;

__END__

=head1 NAME

jPod::CPAN::Dist

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
