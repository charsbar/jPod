package jPod::Command;

use strict;
use warnings;
use base qw/CLI::Dispatch::Command/;
use jPod::Log;
use jPod::Context;

sub run {
    my $self = shift;

    my $context = jPod::Context->new(home => $self->{home});

    $self->_run($context, @_);
}

1;

__END__

=head1 NAME

jPod::Command

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 run

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
