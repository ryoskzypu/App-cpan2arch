# NAME

cpan2arch - generate PKGBUILD from CPAN metadata

# SYNOPSIS

**cpan2arch** \[*OPTION*\]... *MODULE* \[*VERSION*\]

Options:

```
-w, --write       write to PKGBUILD in current dir
    --force       overwrite existing PKGBUILD
-u, --update      rewrite PKGBUILD (show comparison + preserve attribs + bump pkgrel)
-c, --clear       clear all caches before HTTP requests
    --clear-mcpan clear MetaCPAN cache
    --clear-arch  clear Arch Linux cache
-h, --help        show this help and exit
-v, --version     show version info and exit
```

*VERSION* is only supported for distribution names, not module names.

Examples:

```shell
$ cpan2arch -w Foo::Bar        # Module
$ cpan2arch -w Foo-Bar v1.0.0  # Dist + version
```

# DESCRIPTION

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

See ["PKGBUILD EXAMPLE" in App::cpan2arch::WritePkgbuild](https://metacpan.org/pod/App%3A%3Acpan2arch%3A%3AWritePkgbuild#PKGBUILD-EXAMPLE).

## NOTE

This tool is intended to ease the maintenance of Perl packages through automation,
but blindly relying on it is not recommended since distributions might depend on
external libraries or even have wrong metadata, thus
[manual inspection](https://wiki.archlinux.org/title/AUR_submission_guidelines#Maintaining_packages)
is always advised.

# OPTIONS

- **-w**, **--write**

    Write to a file named `PKGBUILD` in the current directory.

- **--force**

    Overwrite an existing `PKGBUILD` silently.

- **-u**, **--update**

    Rewrite the `PKGBUILD` file in the current directory using the generated `PKGBUILD`:

    - [`.SRCINFO`](https://wiki.archlinux.org/title/.SRCINFO) metadata is compared
    against the generated `PKGBUILD` metadata to show differences.
    - Contributor attributions are preserved and `pkgrel` is bumped whenever `pkgver`
    numbers from both metadatas are equal.
    - `epoch` is added or bumped whenever a newer version breaks pacman's
    [version comparison logic](https://man.archlinux.org/man/vercmp.8).

    **Notes**

    - Intended to quickly update obsolete `PKGBUILD`s from adopted AUR Perl packages.
    - Only metadata differences are shown in the comparison table and printed to `STDERR`,
    so `PKGBUILD` syntax and functions are ignored.

        Example:

        ```
        +--------------+------------------+---------------------------------+------------------------+
        | Variable     | .SRCINFO         | Generated                       | Status                 |
        +--------------+------------------+---------------------------------+------------------------+
        | checkdepends | -                | N/A                             | Missing from Generated |
        | checkdepends | perl-test-simple | -                               | Only in .SRCINFO       |
        | depends      | -                | perl-version, perl>=5.10.1      | Only in Generated      |
        | pkgdesc      | Bogus abstract   | Visually debug regexes in-place | Differs                |
        +--------------+------------------+---------------------------------+------------------------+
        ```

    - **--write** and **--force** are implied.
    - To only update `pkgver`, `pkgrel`,
    and `sha256sums`, use [`pkgctl version upgrade`](https://man.archlinux.org/man/extra/devtools/pkgctl-version-upgrade.1),
    not this.

- **-c**, **--clear**
- **--clear-mcpan**
- **--clear-arch**

    Clear all caches, or only MetaCPAN or Arch Linux cache, before HTTP requests to
    refresh stale data.

- **-h**, **--help**

    Display a summary of options and exit.

- **-v**, **--version**

    Display the **cpan2arch** version number and exit.

## COMPLETION

To enable tab completion in bash, put the script in the `PATH` and run this
in the shell or add it to a bash startup file (e.g. `/etc/bash.bashrc` or `~/.bashrc`):

```shell
complete -C cpan2arch cpan2arch
```

Note that [Getopt::Long::More](https://metacpan.org/pod/Getopt%3A%3ALong%3A%3AMore) is required.

# EXIT STATUS

```
0  success
1  general failure
2  command-line usage error
```

# ENVIRONMENT

- **C2A\_PACKAGER**

    If set, overrides the default packager attribution info. Default: `Your Name <email@domain.tld>`.

- **C2A\_USER\_AGENT**

    If set, overrides the default user agent string. Default: `App::cpan2arch/$VERSION`.

- **C2A\_CACHE\_MCPAN\_PATH**

    If set, overrides the default MetaCPAN cache path. Default: `/tmp/mcpan_cache`.

- **C2A\_CACHE\_ARCH\_PATH**

    If set, overrides the default Arch Linux cache path. Default: `/tmp/arch_cache`.

- **C2A\_CACHE\_EXPIRATION**

    If set, overrides the default cache expiration. Default: `1d`.

- **C2A\_CACHE\_IGNORE**

    If true, disables the cache for HTTP requests. Default: `false`.

- **C2A\_DEBUG**

    If true, displays debug information to `STDERR` (Requires [Data::Printer](https://metacpan.org/pod/Data%3A%3APrinter)).
    Default: `false`.

# BUGS

Report bugs at [https://github.com/ryoskzypu/App-cpan2arch/issues](https://github.com/ryoskzypu/App-cpan2arch/issues).

# AUTHOR

ryoskzypu <ryoskzypu@proton.me>

# SEE ALSO

- [https://blogs.perl.org/users/neilb/2017/04/an-introduction-to-distribution-metadata.html](https://blogs.perl.org/users/neilb/2017/04/an-introduction-to-distribution-metadata.html)
- [https://neilb.org/2015/09/25/dependencies-model.html](https://neilb.org/2015/09/25/dependencies-model.html)
- [https://blogs.perl.org/users/neilb/2016/11/an-overview-of-metacpan.html](https://blogs.perl.org/users/neilb/2016/11/an-overview-of-metacpan.html)
- [SRCINFO(5)](https://man.archlinux.org/man/SRCINFO.5)
- [PKGBUILD(5)](https://man.archlinux.org/man/core/pacman/PKGBUILD.5)

This module ships with a similar utility that generates a `PKGBUILD`, but it is
tied to [CPANPLUS](https://metacpan.org/pod/CPANPLUS) and does more stuff like packaging and installing CPAN modules
on Arch using `makepkg` and `pacman`, without depending on the AUR.

- [CPANPLUS::Dist::Arch](https://metacpan.org/pod/CPANPLUS%3A%3ADist%3A%3AArch)

# COPYRIGHT

Copyright © 2026 ryoskzypu

MIT-0 License. See LICENSE for details.
