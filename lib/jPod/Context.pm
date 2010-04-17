package jPod::Context;

use strict;
use warnings;
use File::HomeDir ();
use Path::Extended;
use Sub::Install 'reinstall_sub';
use jPod::Log;

our @DIRS = qw/page pod src work/;

sub new {
    my ($class, %args) = @_;

    my $home = $args{home}
            || $ENV{JPOD_HOME}
            || File::HomeDir->my_home;

    my $self = bless { home => dir($home) }, $class;

    foreach my $dir (@DIRS) {
        reinstall_sub({
            as   => $dir,
            code => sub { shift->{home}->subdir('perldoc', $dir) },
        });
    }

    $self;
}

sub home        { shift->{home} }
sub private     { dir(shift->{home}, '.jpod'); }
sub directories { (@DIRS, 'private') }

1;

__END__

=head1 NAME

jPod::Context

=head1 DESCRIPTION

=head1 METHODS

=head2 new

=head2 home

=head2 private

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
