[![CI](https://github.com/ryoskzypu/App-cpan2arch/actions/workflows/ci.yml/badge.svg?branch=main&event=push)](https://github.com/ryoskzypu/App-cpan2arch/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/github/ryoskzypu/App-cpan2arch/badge.svg?branch=main)](https://coveralls.io/github/ryoskzypu/App-cpan2arch?branch=main)

# App::cpan2arch

**cpan2arch** is a command-line utility that generates an [Arch Linux](https://wiki.archlinux.org/title/Arch_Linux)
[`PKGBUILD`](https://wiki.archlinux.org/title/PKGBUILD) based on module/distribution
[metadata](https://metacpan.org/pod/CPAN::Meta::Spec). It relies on the
[MetaCPAN API](https://github.com/metacpan/metacpan-api) to fetch metadata and
the [Official repositories web interface](https://wiki.archlinux.org/title/Official_repositories_web_interface)
\+ [Aurweb RPC interface](https://wiki.archlinux.org/title/Aurweb_RPC_interface)
for Arch Linux packages information, using caching to speed up repeated requests
and reduce server load.

Warnings about flagged out-of-date packages, missing packages, license problems,
and other issues are added as comments in the `PKGBUILD` to inform the packager.

The generated `PKGBUILD` follows [Perl package guidelines](https://wiki.archlinux.org/title/Perl_package_guidelines)
and is printed to `STDOUT` by default, unless **--update** or **--write** is passed.

## NOTE

This tool is intended to ease the maintenance of Perl packages through automation,
but blindly relying on it is not recommended since distributions might depend on
external libraries or even have wrong metadata, thus
[manual inspection](https://wiki.archlinux.org/title/AUR_submission_guidelines#Maintaining_packages)
is always advised.

## Installation

To download and install this module directly with [cpanminus](https://metacpan.org/pod/App::cpanminus):

```shell
$ cpanm https://github.com/ryoskzypu/App-cpan2arch.git
```

To do it manually, run the following commands (after cloning the repository):

```shell
$ cd App-cpan2arch
$ perl Makefile.PL
$ make
$ make test
$ make install
```

## Support and documentation

You can find documentation for this module in [docs](docs/) or with the
`perldoc` command (after installing):

```shell
$ perldoc cpan2arch
$ perldoc App::cpan2arch
```

You can also look for information at:

- GitHub issue tracker (report bugs here)

    https://github.com/ryoskzypu/App-cpan2arch/issues

- Search CPAN

    https://metacpan.org/dist/App-cpan2arch

## Copyright

Copyright © 2026 ryoskzypu

MIT-0 License. See LICENSE for details.
