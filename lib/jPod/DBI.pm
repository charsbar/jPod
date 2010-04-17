package jPod::DBI;

use strict;
use warnings;
use Carp;
use DBI;

sub new {
    my ($class, $file) = @_;

    $file ||= ':memory:';

    my $dbh = DBI->connect( "dbi:SQLite:$file", '', '', {
        sqlite_use_immediate_transaction => 1,
        AutoCommit => 1, PrintError => 0, RaiseError => 1
    }) or croak $!;

    if ($file && substr($file, 0, 1) ne ':' && !-s $file) {
        my $table   = $class->table;
        my %columns = $class->columns;
        my $schema  = join ', ',
                      map { "$_ $columns{$_}" }
                      keys %columns;
        $dbh->do("create table $table ($schema)");
    }

    bless { file => $file, dbh => $dbh }, $class;
}

sub select {
    my ($self, $where, @bind_values) = @_;

    my $sql = join ' ', "select * from", $self->table, $where;

    $self->{dbh}->selectrow_hashref($sql, undef, @bind_values);
}

sub select_all {
    my ($self, $where, @bind_values) = @_;

    my $sql = join ' ', "select * from", $self->table, $where;

    my $sth = $self->{dbh}->prepare($sql) or return;
       $sth->execute(@bind_values)        or return;

    my @founds;
    while ( my $found = $sth->fetchrow_hashref ) {
        push @founds, $found;
    }
    $sth->finish;

    return @founds;
}

1;

__END__

=head1 NAME

jPod::DBI

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
