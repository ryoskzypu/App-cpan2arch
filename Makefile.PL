use v5.40.0;

use strict;
use warnings;

use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
    NAME             => 'App::cpan2arch',
    AUTHOR           => q{ryoskzypu <ryoskzypu@proton.me>},
    VERSION_FROM     => 'lib/App/cpan2arch.pm',
    ABSTRACT_FROM    => 'lib/App/cpan2arch.pm',
    LICENSE          => 'open_source',
    MIN_PERL_VERSION => 'v5.40.0',
    EXE_FILES        => [
        'bin/cpan2arch',
    ],
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => '6.64',
    },
    TEST_REQUIRES => {
        'Capture::Tiny'   => '0.50',
        'Cwd'             => '0',
        'Devel::CheckBin' => '0.04',
        'File::Basename'  => '0',
        'Path::Tiny'      => '0.150',
        'Test2::V1'       => '0',
        'Text::Diff'      => '1.45',
        'builtin'         => '0',
    },
    PREREQ_PM => {
        'CHI'                     => '0.61',
        'Capture::Tiny'           => '0.50',
        'Devel::CheckBin'         => '0.04',
        'Encode'                  => '0',
        'Encode::Locale'          => '1.05',
        'File::Basename'          => '0',
        'Future::AsyncAwait'      => '0.71',
        'HTTP::Tiny::Mech'        => '1.001002',
        'JSON::MaybeXS'           => '1.004008',
        'List::Compare'           => '0.55',
        'List::Util'              => '0',
        'MetaCPAN::Client'        => '2.043000',
        'Module::CoreList'        => '5.20260420',
        'Mojo::Log'               => '0',
        'Mojo::Promise'           => '0',
        'Mojo::UserAgent::Cached' => '1.25',
        'Mojolicious'             => '9.45',
        'Object::Pad'             => '0.800',
        'Path::Tiny'              => '0.150',
        'Pod::Usage'              => '0',
        'Scalar::Util'            => '0',
        'Software::LicenseUtils'  => '0.104007',
        'Term::ReadKey'           => '2.38',
        'Term::Table'             => '0',
        'Time::Piece'             => '0',
        'WWW::Mechanize::Cached'  => '1.56',
        'builtin'                 => '0',
        'version'                 => '0.9934',
    },
    META_MERGE => {
        'meta-spec' => { version => 2 },
        no_index    => {
            directory => [
                qw<
                    eg
                    examples
                    share
                    xt
                >
            ],
        },
        prereqs => {
            develop => {
                recommends => {
                    'App::CPANTS::Lint' => '0',
                    'Data::Printer'     => '0',
                    'Devel::Cover'      => '0',
                    'Devel::NYTProf'    => '0',
                    'Perl::Critic'      => '0',
                    'Perl::Tidy'        => '0',
                },
                requires => {
                    'Test::CPAN::Changes' => '0',
                    'Test::Kwalitee'      => '0',
                    'Test::Perl::Critic'  => '0',
                    'Test::Pod'           => '0',
                    'Test::Pod::Coverage' => '0',
                    'Test::Spelling'      => '0',
                },
            },
            runtime => {
                recommends => {
                    'Data::Printer'      => '0',
                    'Getopt::Long::More' => '0.007',
                },
            },
            test => {
                recommends => {
                    'Data::Printer' => '0',
                },
            },
        },
        resources => {
            repository => {
                type => 'git',
                url  => 'https://github.com/ryoskzypu/App-cpan2arch.git',
                web  => 'https://github.com/ryoskzypu/App-cpan2arch',
            },
            bugtracker => {
                web => 'https://github.com/ryoskzypu/App-cpan2arch/issues',
            },
        },
        x_contributors => [
            q{ryoskzypu <ryoskzypu@proton.me>},
        ],
        x_spdx_expression => 'MIT-0',
    },
);

WriteMakefile(%WriteMakefileArgs);
