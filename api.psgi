use strict;
use warnings;
use Plack::Request;
use jPod::Context;
use jPod::DBI::ExternalSources;
use HTTP::Status qw/status_message/;

my $context = jPod::Context->new;
my $dbi = jPod::DBI::ExternalSources->new(
    $context->private->file('external.db')
);

my $app = sub {
    my $env = shift;
    my $req = Plack::Request->new($env);
    my (undef, $type, $module) = split '/', $req->uri->path;

    sub error {
        my $code = shift;
        return [
            $code,
            [ 'Content-Type' => 'text/plain',
            ],
            [ status_message($code) ],
        ];
    }

    sub redirect {
        my $location = shift;
        return [
            303,
            [ 'Location' => $location,
            ],
            [],
        ];
    }

    return error(404) unless $type && $module;

    my $found = $dbi->look_for($module)
        or return error(404);

    if ( $type eq 'pod' && $found->{pod_url} ) {
        return redirect($found->{pod_url});
    }
    elsif ( $type eq 'html' && $found->{html_url} ) {
        return redirect($found->{html_url});
    }

    return error(404);
};
