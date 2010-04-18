package jPod::Script::RegisterPerldocjpPod;

use strict;
use warnings;
use base qw/jPod::Command/;
use jPod::ExternalSource::Perldocjp;
use jPod::ExternalSource::Entry::Perldocjp;
use jPod::DBI::ExternalSources;

sub _run {
    my ($self, $context, @args) = @_;

    my $perldocjp = jPod::ExternalSource::Perldocjp->new(
        dir => $context->private->subdir('perldocjp'),
    );

    my @found = $perldocjp->find_pods;

    my $dbfile = $context->private->file('external.db');
    my $dbi = jPod::DBI::ExternalSources->new($dbfile);

    my $counter = 0;
    $dbi->begin_transaction;
    for my $entry (@found) {
        unless (++$counter % 1000) {
            $dbi->commit;
            $counter = 0;
        }
        $dbi->insert_or_update( $entry->as_hash );

        my $name_v = $entry->name . ' ' . $entry->version;
        $self->log( debug => "registered $name_v" );
    }
    $dbi->commit;
    $dbi->end_transaction;
    $dbi->{dbh}->disconnect;
}

1;

__END__

=head1 NAME

jPod::Script::RegisterPerldocjpPod

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
