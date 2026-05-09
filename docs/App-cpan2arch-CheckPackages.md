# NAME

App::cpan2arch::CheckPackages - check existence of Arch Linux packages

# SYNOPSIS

```perl
use App::cpan2arch;

my $cpan2arch = App::cpan2arch->new;

...
```

# DESCRIPTION

This role handles analysis of whether prerequisite distributions exist as packages
in the Arch Linux Official/AUR repositories, checks flagged out-of-date packages,
and builds `PKGBUILD` data.

# METHODS

## check\_packages

```perl
$cpan2arch->check_packages;
```

Takes no arguments and returns `0` on success.

# BUGS

Report bugs at [https://github.com/ryoskzypu/App-cpan2arch/issues](https://github.com/ryoskzypu/App-cpan2arch/issues).

# AUTHOR

ryoskzypu <ryoskzypu@proton.me>

# SEE ALSO

- [https://wiki.archlinux.org/title/Official\_repositories\_web\_interface](https://wiki.archlinux.org/title/Official_repositories_web_interface)
- [https://wiki.archlinux.org/title/Aurweb\_RPC\_interface](https://wiki.archlinux.org/title/Aurweb_RPC_interface)

# COPYRIGHT

Copyright © 2026 ryoskzypu

MIT-0 License. See LICENSE for details.
