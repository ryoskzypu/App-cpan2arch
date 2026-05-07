use v5.40.0;

use strict;
use warnings;

use Object::Pad 0.800;

package App::cpan2arch::GetMetadata;  # For toolchain compatibility.
role App::cpan2arch::GetMetadata;

use builtin      qw< is_bool >;
use Scalar::Util qw< looks_like_number >;

our $VERSION = 'v1.0.0';

field $_mcpan;
field %_optionals          :reader;
field $_has_multi_licenses :reader = false;
field %_meta               :reader :writer;

# Get CPAN metadata from MetaCPAN's API.
#
# References:
#   https://github.com/metacpan/metacpan-api/blob/master/docs/API-docs.md
method get_metadata ()
{
    $self->_psub;

    $self->_init_mcpan;

    # Get the module/distribution and its release.
    my $dist;
    my $rel;
    {
        my %args    = $self->args;
        my $module  = $args{module};
        my $version = $args{version};
        my $mod;

        # Only request for a module if it does not look like a dist and no version
        # argument is passed, otherwise treat it as dist.
        if ( $module !~ /-/ && !defined $version ) {
            $mod = $self->_get_module($module);
            $self->_pdbg("found module\n\n") if defined $mod;
        }

        # Since modules and dists names can be ambiguous, e.g. Reply, do not exit
        # if a module request fails, but fallback as dist.
        $dist = defined $mod ? $mod->distribution : $module;

        $self->_pdbg("Dist\n");
        $self->_pdump( '$dist', \$dist, "\n" );

        $rel = $self->_get_release($dist);
        return 1 if $rel == 1;

        $self->_pdbg("Release\n");
        $self->_pdump( '$rel->data', \$rel->data, "\n" );
    }

    # Find Module::Install, license, and XS files in the dist.
    my %files;
    {
        no warnings qw< experimental::builtin >;

        foreach my $type ( qw< mi license xs > ) {
            my $ret = $self->_find_files( $dist, $type );
            return 1 if !is_bool($ret) && looks_like_number($ret) && $ret == 1;

            $files{$type} = $ret;
            $self->_pdump( "\$files{$type}", \$ret, "\n" );
        }
    }

    # Get 'optionals_features' descriptions (will be added to the optdepends array).
    # See https://metacpan.org/pod/CPAN::Meta::Spec#optional_features.
    {
        foreach my ( $feature, $feat_info ) ( $rel->metadata->{optional_features}->%* ) {

            foreach my ( $phase, $phase_info ) ( $feat_info->{prereqs}->%* ) {

                foreach my ( $relation, $rel_info ) ( $phase_info->%* ) {

                    foreach my ( $module, $version ) ( $rel_info->%* ) {
                        push $_optionals{$module}->@*, $feat_info->{description};
                    }
                }
            }
        }

        $self->_pdump( '%_optionals', \%_optionals, "\n" );
    }

    %_meta = (
        author             => $rel->author,
        name               => $rel->name,
        dist               => $rel->distribution,
        version            => $rel->version,
        abstract           => $rel->abstract,
        license            => $rel->license,
        spdx_expression    => $rel->metadata->{x_spdx_expression},
        dependency         => $rel->dependency,
        download_url       => $rel->download_url,
        checksum           => $rel->checksum_sha256,
        has_module_install => $files{mi},
        has_license        => $files{license},
        has_multi_licenses => $_has_multi_licenses,
        has_xs             => $files{xs},
    );
    $self->_pdump( '%_meta', \%_meta, "\n" );

    return 0;
}

# Create a MetaCPAN::Client instance.
method _init_mcpan ()
{
    # Lazy-load to improve startup time.
    require MetaCPAN::Client;
    MetaCPAN::Client->VERSION('2.043000');

    my %env     = $self->env;
    my %opts    = $self->opts;
    my $ua      = $env{user_agent};
    my $timeout = 10;

    # Use CHI as the cache backend.
    my $chi;
    {
        require CHI;
        CHI->VERSION('0.61');

        $chi = CHI->new(
            driver     => 'File',
            root_dir   => $env{cache_mcpan_path},
            expires_in => $env{cache_expiration},
        ) unless $env{cache_ignore};

        $chi->clear
          if defined $chi
          && ( defined $opts{clear} || defined $opts{clear_mcpan} );
    }

    if ( !$env{cache_ignore} ) {
        require HTTP::Tiny::Mech;
        HTTP::Tiny::Mech->VERSION('1.001002');

        require WWW::Mechanize::Cached;
        WWW::Mechanize::Cached->VERSION('1.56');
    }

    $_mcpan = MetaCPAN::Client->new(
        ua => $env{cache_ignore}
        ? HTTP::Tiny->new(
            agent   => $ua,
            timeout => $timeout,
          )
        : HTTP::Tiny::Mech->new(
            agent   => $ua,
            mechua  => WWW::Mechanize::Cached->new( cache => $chi ),
            timeout => $timeout,
        ),
    );

    return $self;
}

method _get_module ($module)
{
    $self->_psub;

    my $prog = $self->prog;
    my $err  = "$prog: failed to fetch $module module\n";

    my $mod = do {
        try {
            $_mcpan->module(
                $module,
                { fields => 'distribution' },
            );
        }
        catch ($e) {
            warn $e;
            undef;
        }
    };

    if ( !defined $mod ) {
        warn "$prog: failed to fetch $module module\n";
        $self->_pdbg("\n");

        return undef;
    }

    return $mod;
}

# References:
#   https://blogs.perl.org/users/neilb/2016/12/working-with-the-metacpan-api.html.
method _get_release ($dist)
{
    $self->_psub;

    my %args    = $self->args;
    my $version = $args{version};
    my $prog    = $self->prog;

    my $rel = do {
        try {
            $_mcpan->release(
                {
                    all => [
                        # For some reason URI dist is unauthorized and only returns
                        # the latest version; maybe related to PAUSE permissions
                        # since it had several dists merged.
                        $dist ne 'URI'
                        ? { authorized => 'true' }
                        : (),

                        { distribution => $dist },

                        defined $version
                        ? { version => $version }
                        : { status  => 'latest' },
                    ],
                },
                # Return only these fields.
                {
                    '_source' => [
                        qw<
                            author
                            name
                            distribution
                            version
                            abstract
                            license
                            dependency
                            download_url
                            checksum_sha256
                            metadata
                        >
                    ],
                },
            )->next;
        }
        catch ($e) {
            warn $e;
            undef;
        }
    };

    if ( !defined $rel ) {
        warn "$prog: failed to fetch $dist dist release\n";
        return 1;
    }

    return $rel;
}

# Check if the distribution has some type of files.
#
# References:
#   https://github.com/metacpan/metacpan-examples/blob/main/scripts/file/1-get-files-in-dist-es.pl
#   https://metacpan.org/release/MICKEY/MetaCPAN-Client-2.039000/source/examples/es_filter.pl
#   https://github.com/metacpan/metacpan-examples/blob/main/scripts/file/5-size-of-cpan.pl
#   https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-bool-query
#   https://www.elastic.co/docs/reference/query-languages/query-dsl/term-level-queries
#   https://www.elastic.co/docs/reference/query-languages/query-dsl/regexp-syntax
method _find_files ( $dist, $type )
{
    $self->_psub;
    $self->_pdump( '$type', \$type, '' );

    my %args    = $self->args;
    my $version = $args{version};
    my $prog    = $self->prog;

    my $files = do {
        try {
            $_mcpan->all(
                'files',
                {
                    '_source' => [ qw< name > ],

                    # Narrow down the search to speed it up.
                    es_filter => {
                        bool => {
                            must => [
                                { term => { authorized   => 'true' } },
                                { term => { distribution => $dist } },
                                {
                                      term => $type eq 'mi' ? { level => 2 }
                                    : $type eq 'license' ? { level   => 0 }
                                    : $type eq 'xs'      ? { indexed => 'true' }
                                    : (),
                                },
                                {
                                    term => defined $version
                                    ? { version => $version }
                                    : { status  => 'latest' },
                                },

                                $type eq 'mi'
                                ? { regexp => { path => 'inc/Module/.*' } }
                                : (),

                                {
                                    regexp => {
                                          name => $type eq 'mi' ? 'Install\.pm'
                                        : $type eq 'license' ? '(LICEN[CS]E|COPYRIGHT|COPYING)([-_.].+)?'
                                        : $type eq 'xs'      ? 'typemap|.+\.xs'
                                        : (),
                                    },
                                },
                            ],
                            must_not => [
                                { term => { directory => 'true' } },

                                $type eq 'xs'
                                ? { regexp => { path => '(inc|bin|script|eg|examples|share|x?t)/.*' } }
                                : (),
                            ],
                        },
                    },
                },
            );
        }
        catch ($e) {
            warn $e;
            undef;
        }
    };

    if ( !defined $files ) {
        warn "$prog: failed to find $dist $type files\n";
        return 1;
    }

    my $total = $files->total;
    $self->_pdump( '$total', \$total, '' );

    my $found = false;

    if ( $type eq 'mi' ) {
        # inc/Module/Install.pm
        if ( $total > 0 ) {
            $found = true;
            $self->_pdbg("found Install.pm\n");
        }
    }
    elsif ( $type eq 'license' ) {
        my @licenses;

        while ( my $file = $files->next ) {
            my $fname = $file->{data}{name};
            push @licenses, $fname;

            $self->_pdbg("found license: $fname\n");
        }

        # Multiple licenses is uncommon in Perl, so just return a single license
        # for simplicity, but flag multiple files.
        @licenses            = sort @licenses;
        $found               = $licenses[0];
        $_has_multi_licenses = true if scalar @licenses > 1;

        $self->_pdump( '@licenses', \@licenses, '' );
    }
    elsif ( $type eq 'xs' ) {
        if ( $total > 0 ) {
            $found = true;
            $self->_pdbg("found XS file\n");
        }
    }

    return $found;
}

=encoding UTF-8

=for highlighter language=perl

=head1 NAME

App::cpan2arch::GetMetadata - get CPAN metadata from MetaCPAN's API

=head1 SYNOPSIS

  use App::cpan2arch;

  my $cpan2arch = App::cpan2arch->new;

  ...

=head1 DESCRIPTION

This role handles the fetching of module/distribution metadata from
L<MetaCPAN's|https://github.com/metacpan/metacpan-api> API.

=head1 METHODS

=head2 get_metadata

  $cpan2arch->get_metadata;

Takes no arguments and returns C<0> on success.

=head1 BUGS

Report bugs at L<https://github.com/ryoskzypu/App-cpan2arch/issues>.

=head1 AUTHOR

ryoskzypu <ryoskzypu@proton.me>

=head1 SEE ALSO

=over 4

=item *

L<https://blogs.perl.org/users/neilb/2016/12/working-with-the-metacpan-api.html>

=item *

L<MetaCPAN::Client>

=back

=head1 COPYRIGHT

Copyright © 2026 ryoskzypu

MIT-0 License. See LICENSE for details.

=cut
