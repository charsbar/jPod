package jPod::Script::FindExternalTranslation;

use strict;
use warnings;
use base qw/jPod::Command/;
use jPod::DBI::ExternalSources;

sub _run {
    my ($self, $context, $name, @args) = @_;

    my $file = $context->private->file('external.db');

    my $db = jPod::DBI::ExternalSources->new($file);

    my $found = $db->look_for($name) or return;

    print $found->{url}, "\n";
}

1;

__END__

=head1 NAME

jPod::Script::FindExternalTranslation - find a url for external translation

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
