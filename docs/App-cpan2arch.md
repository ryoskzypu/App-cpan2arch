# NAME

App::cpan2arch - generate PKGBUILD from CPAN metadata

# SYNOPSIS

```perl
use App::cpan2arch;

App::cpan2arch->new->init(@ARGV)->run;
```

# DESCRIPTION

**App::cpan2arch** provides the logic behind the [cpan2arch](https://metacpan.org/pod/cpan2arch) wrapper script,
handling processing of environment variables and options, HTTP requests for
CPAN metadata and Arch Linux package information, translating dependencies
between CPAN and `PKGBUILD`, and generating and outputting the `PKGBUILD`.
See ["DESCRIPTION" in cpan2arch](https://metacpan.org/pod/cpan2arch#DESCRIPTION) for details.

# METHODS

## new

```perl
my $cpan2arch = App::cpan2arch->new;
```

Constructs and returns a new **App::cpan2arch** instance. Takes no arguments.

## init

```perl
$cpan2arch->init(@ARGV);
```

Reads environment variables and parses the list given (typically from `@ARGV`)
for options. Returns `self`.

## run

```perl
$cpan2arch->run;
```

Performs the program actions:

- Fetches module/distribution metadata from [MetaCPAN's](https://github.com/metacpan/metacpan-api)
API.
- Merges [CPAN prerequisites](https://metacpan.org/pod/CPAN::Meta::Spec#PREREQUISITES)
to [PKGBUILD dependencies](https://man.archlinux.org/man/alpm-package-relation.7).
- Checks whether prerequisite distributions exist as packages on Arch's Official/AUR
repositories to build `PKGBUILD` data.
- Generates the `PKGBUILD` to write to `STDOUT` or file.

Takes no arguments and returns `0` on success.

# ERRORS

This module reports errors to `STDERR` and exits with a non-zero status in the
following:

- Missing runtime dependencies ([Data::Printer](https://metacpan.org/pod/Data%3A%3APrinter), [vercmp](https://man.archlinux.org/man/vercmp.8))
- Invalid command-line options
- Network/JSON issues
- MetaCPAN/Arch API issues
- Dist tarball issues
- `perl` version issues
- [Module::CoreList](https://metacpan.org/pod/Module%3A%3ACoreList) issues
- File access/permission/metadata issues

See ["EXIT-STATUS" in cpan2arch](https://metacpan.org/pod/cpan2arch#EXIT-STATUS) for exit code details.

# BUGS

Report bugs at [https://github.com/ryoskzypu/App-cpan2arch/issues](https://github.com/ryoskzypu/App-cpan2arch/issues).

# AUTHOR

ryoskzypu <ryoskzypu@proton.me>

# SEE ALSO

- [App::cpan2arch::GetMetadata](https://metacpan.org/pod/App%3A%3Acpan2arch%3A%3AGetMetadata)
- [App::cpan2arch::MergePrereqs](https://metacpan.org/pod/App%3A%3Acpan2arch%3A%3AMergePrereqs)
- [App::cpan2arch::CheckPackages](https://metacpan.org/pod/App%3A%3Acpan2arch%3A%3ACheckPackages)
- [App::cpan2arch::WritePkgbuild](https://metacpan.org/pod/App%3A%3Acpan2arch%3A%3AWritePkgbuild)

# COPYRIGHT

Copyright © 2026 ryoskzypu

MIT-0 License. See LICENSE for details.
