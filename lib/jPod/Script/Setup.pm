package jPod::Script::Setup;

use strict;
use warnings;
use base qw/jPod::Command/;

sub _run {
    my ($self, $context, @args) = @_;

    for my $dir ($context->directories) {
        unless ($context->$dir->exists) {
            $context->$dir->mkdir
                and $self->log( info => "created $dir directory" );
        }
    }
}

1;

__END__

=head1 NAME

jPod::Script::Setup - set up directories

=head1 SYNOPSIS

  > perl jpod setup

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
