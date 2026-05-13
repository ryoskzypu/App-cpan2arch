# NAME

App::cpan2arch::WritePkgbuild - generate and output PKGBUILD

# SYNOPSIS

```perl
use App::cpan2arch;

my $cpan2arch = App::cpan2arch->new;

...
```

# DESCRIPTION

This role handles the generation and output of the `PKGBUILD` for the module/distribution.

# METHODS

## generate\_pkgbuild

```perl
$cpan2arch->generate_pkgbuild;
```

Takes no arguments and returns `self`.

## write\_pkgbuild

```perl
$cpan2arch->write_pkgbuild;
```

Takes no arguments and returns `0` on success.

## PKGBUILD EXAMPLE

```bash
# Maintainer: Your Name <email@domain.tld>

_author=RYOSKZYPU
_dist=App-cpan2arch
pkgname=perl-${_dist@L}
pkgver=v1.0.0
pkgrel=1
pkgdesc='generate PKGBUILD from CPAN metadata'
arch=('any')
url=https://metacpan.org/dist/$_dist
license=('MIT-0')
depends=(
    'perl-archive-tar'
    'perl-capture-tiny>=0.50'
    'perl-chi>=0.61'
    'perl-cpanel-json-xs>=4.40'
    'perl-devel-checkbin>=0.04'
    'perl-encode'
    'perl-encode-locale>=1.05'
    'perl-io-socket-ssl>=2.098'
    'perl-list-compare>=0.55'
    'perl-module-corelist>=5.20260420'
    'perl-mojo-useragent-cached>=1.25'  # Package for Mojo::UserAgent::Cached is missing.
    'perl-mojolicious'
    'perl-object-pad>=0.825'
    'perl-path-tiny>=0.150'
    'perl-pathtools'
    'perl-pod-usage'
    'perl-scalar-list-utils'
    'perl-software-license>=0.104007'
    'perl-term-readkey>=2.38'
    'perl-term-table'
    'perl-time-piece'
    'perl-version>=0.9934'
    'perl>=5.42.0'
)
makedepends=('perl-extutils-makemaker')
checkdepends=(
    'perl-capture-tiny>=0.50'
    'perl-devel-checkbin>=0.04'
    'perl-path-tiny>=0.150'
    'perl-test-simple'
    'perl-text-diff>=1.45'
)
optdepends=(
    'perl-data-printer>=1.002001'
    'perl-getopt-long-more>=0.007'  # Package for Getopt::Long::More is missing.
)
options=('!emptydirs')
source=("https://cpan.metacpan.org/authors/id/${_author::1}/${_author::2}/$_author/$_dist-$pkgver.tar.gz")
sha256sums=('9bdd428eb2afc2f836216ad79afd9ebf2b935201be3067da11044b3b740f096f')

build()
{
    cd "$_dist-$pkgver"

    unset PERL_MM_OPT PERL5LIB PERL_LOCAL_LIB_ROOT
    export PERL_MM_USE_DEFAULT=1

    /usr/bin/perl Makefile.PL NO_PACKLIST=1 NO_PERLLOCAL=1
    make
}

check()
{
    cd "$_dist-$pkgver"

    unset PERL5LIB PERL_LOCAL_LIB_ROOT

    make test
}

package()
{
    cd "$_dist-$pkgver"

    unset PERL5LIB PERL_LOCAL_LIB_ROOT

    make install INSTALLDIRS=vendor DESTDIR="$pkgdir"
    install -Dm644 LICENSE -t "$pkgdir/usr/share/licenses/$pkgname/"
}
```

# BUGS

Report bugs at [https://github.com/ryoskzypu/App-cpan2arch/issues](https://github.com/ryoskzypu/App-cpan2arch/issues).

# AUTHOR

ryoskzypu <ryoskzypu@proton.me>

# SEE ALSO

- [https://wiki.archlinux.org/title/Perl\_package\_guidelines](https://wiki.archlinux.org/title/Perl_package_guidelines)
- [SRCINFO(5)](https://man.archlinux.org/man/SRCINFO.5)
- [PKGBUILD(5)](https://man.archlinux.org/man/core/pacman/PKGBUILD.5)

# COPYRIGHT

Copyright © 2026 ryoskzypu

MIT-0 License. See LICENSE for details.
