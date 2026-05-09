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
