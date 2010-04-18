package jPod::ExternalSource::Entry::Perldocjp;

use strict;
use warnings;
use version;

sub new {
    my ($class, %args) = @_;

    $args{version} ||= 0;
    $args{version} =~ tr/0-9.//cd;
    $args{version} = version->new($args{version})->numify;

    bless \%args, $class;
}

sub name     { shift->{name} }
sub version  { shift->{version} }
sub path     { shift->{path} }
sub html_url { "http://perldoc.jp/" . shift->{path} }
sub pod_url  { shift->html_url . '.pod' }
sub source   { 'perldocjp' }

sub as_hash {
    my $self = shift;

    map { $_ => $self->$_ } qw/name version pod_url html_url source/;
}

1;

__END__

=head1 NAME

jPod::ExternalSource::Entry::Perldocjp

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
