package jPod::ExternalSource::Perldocjp;

use strict;
use warnings;
use Path::Extended;
use version;
use jPod::ExternalSource::Entry::Perldocjp;

my %known_mismatch = map { chomp; $_ => 1 } <DATA>;

sub url { 'http://sourceforge.jp/cvs/view/perldocjp.tar.gz' };

sub new {
    my ($class, %args) = @_;

    bless \%args, $class;
}

sub find_pods {
    my ($self, %args) = @_;

    my $dir = dir( $self->{dir} );

    my (@found, @errors);
    $dir->recurse( depthfirst => 1, callback => sub {
        my $file = shift;
        return unless -f $file;

        my $path = $file->relative($dir);

        if (my ($distv) = $path =~ m{docs/modules/([^/]+)}) {
            my ($dist, $version) = $distv =~ /^(.+?)\-([\d._-]+)$/;

            my ($basename) = $path =~ m{([^/]+?)(\-[\d._]+)?(\.pm)?\.pod$};
            $basename =~ s/\-/::/g;
            my $content = $file->slurp;
            $content =~ s/[A-Z]<<?([^>]+)>>?/$1/g;
            my ($package) = $content =~ /^\s*([A-Za-z][A-Za-z0-9:_]+?)(?:\.pm|::)?\s+/m;
            unless ($package =~ /(?:^|::)$basename$/i) {
                push @errors, "$package mismatch: $path";
                return;
            }
            my ($dist_top) = $package =~ /^([A-Za-z0-9_]+)/;
            unless ($distv =~ /^$dist_top\b/ or $known_mismatch{"$distv/$package"}) {
                push @errors, "$package mismatch: $distv";
                return;
            }

            push @found, jPod::ExternalSource::Entry::Perldocjp->new(
                name    => $package,
                version => $version,
                path    => $path,
                mtime   => $file->mtime,
            );
        }
        elsif (my ($version) = $path =~ m{docs/perl/([\d.]+)}) {
            my ($basename) = $path =~ m{([^/]+?)(\-[\d._]+)?(\.pm)?\.pod$};

            push @found, jPod::ExternalSource::Entry::Perldocjp->new(
                name    => $basename,
                version => $version,
                path    => $path,
                mtime   => $file->mtime,
            );
        }
    });

    $self->{errors} = \@errors;
    $self->{pods}   = \@found;

    wantarray ? @found : \@found;
}

sub errors { @{ shift->{errors} || [] } }

1;

__DATA__
DBD-DB2-0.76/Bundle::DBD::DB2
File-Which-0.05/pwhich
HTTP-WebTest-2.04/wt
HTTP-WebTest-2.04/Bundle::HTTP::WebTest
libapreq-1.0/Apache::Cookie
libapreq-1.0/Apache::Request
libnet-1.12/Net::Cmd
libnet-1.12/Net::Config
libnet-1.12/Net::Domain
libnet-1.12/Net::FTP
libnet-1.12/Net::Netrc
libnet-1.12/Net::NNTP
libnet-1.12/Net::POP3
libnet-1.12/Net::SMTP
libnet-1.12/Net::Time
libwin32-0.26/Win32::OLE::Const
libwin32-0.26/Win32::OLE::Enum
libwin32-0.26/Win32::OLE::NLS
libwin32-0.26/Win32::OLE::Variant
libwin32-0.26/Win32::OLE
libwww-perl-5.813/HTTP::Headers
libwww-perl-5.813/HTTP::Request
libwww-perl-5.813/HTTP::Response
libwww-perl-5.813/LWP::UserAgent
mod_perl-1.29_related/Apache::FakeCookie
mod_perl-1.29_related/Apache::FakeRequest
PAR-0.75/App::Packer::Backend::PAR
PAR-0.75/parl
PAR-0.75/pp
PlRPC-0.2016/Bundle::PlRPC
PlRPC-0.2016/RPC::PlClient
PlRPC-0.2016/RPC::PlServer
Test-Base-0.52/Module::Install::TestBase
Test-Base-0.59/Module::Install::TestBase
YAML-0.62/Test::YAML
YAML-0.62/ysh

__END__

=head1 NAME

jPod::ExternalSource::Perldocjp

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
