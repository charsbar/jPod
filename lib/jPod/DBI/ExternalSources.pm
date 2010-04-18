package jPod::DBI::ExternalSources;

use strict;
use warnings;
use base qw/jPod::DBI/;

sub table { 'external_sources' }

sub columns {(
    name       => 'text',
    version    => 'text',
    url        => 'text',
    source     => 'text',
    updated_on => 'int',
)}

sub unique { qw/ name version source / }

sub look_for {
    my ($self, $name) = @_;

    my $where = 'where name = ?';
    my @bind_values = $name;
    $where .= 'order by updated_on desc limit 1';

    my $found = $self->select( $where, @bind_values ) or return;

    return $found;
}

1;

__END__

=head1 NAME

jPod::DBI::ExternalSources

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
