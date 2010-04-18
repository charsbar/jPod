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

sub begin_transaction { shift->{dbh}->{AutoCommit} = 0; }
sub end_transaction   { shift->{dbh}->{AutoCommit} = 1; }
sub commit   { shift->{dbh}->commit }
sub rollback { shift->{dbh}->rollback }

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

sub insert_or_update {
    my ($self, %hash) = @_;

    my @unique_keys = $self->unique;

    my $where = "where ". join ' and ', map { "$_ = ?" } @unique_keys;
    my @bind_values = @hash{@unique_keys};
    if ($self->select($where, @bind_values)) {
        my @keys = sort keys %hash;
        my $placeholders = join ', ', map { "$_ = ?" } @keys;
        my $sql = join ' ', "update", $self->table,
                            "set $placeholders",
                            "$where";

        $self->{dbh}->do($sql, undef, @hash{@keys}, @bind_values);
    }
    else {
        my @keys = sort keys %hash;
        my $placeholders = substr('?,' x @keys, 0, -1);
        my $sql = join ' ', "insert into", $self->table,
                            "(", join(',', @keys), ")",
                            "values ($placeholders)";

        $self->{dbh}->do($sql, undef, @hash{@keys});
    }
}

sub DESTROY {
    my $self = shift;
    if ( $self->{dbh} ) {
        $self->{dbh}->disconnect;
    }
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
