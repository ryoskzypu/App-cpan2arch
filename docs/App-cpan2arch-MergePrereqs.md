# NAME

App::cpan2arch::MergePrereqs - merge CPAN prerequisites to PKGBUILD dependencies

# SYNOPSIS

```perl
use App::cpan2arch;

my $cpan2arch = App::cpan2arch->new;

...
```

# DESCRIPTION

This role handles the translation of dependencies between
[CPAN](https://metacpan.org/pod/CPAN::Meta::Spec#PREREQUISITES) and
[PKGBUILD](https://man.archlinux.org/man/alpm-package-relation.7) for the
module/distribution.

# METHODS

## merge\_prereqs

```perl
$cpan2arch->merge_prereqs;
```

Takes no arguments and returns `0` on success.

# BUGS

Report bugs at [https://github.com/ryoskzypu/App-cpan2arch/issues](https://github.com/ryoskzypu/App-cpan2arch/issues).

# AUTHOR

ryoskzypu <ryoskzypu@proton.me>

# SEE ALSO

- [https://blogs.perl.org/users/neilb/2017/04/dependency-phases-in-cpan-distribution-metadata.html](https://blogs.perl.org/users/neilb/2017/04/dependency-phases-in-cpan-distribution-metadata.html)
- [https://blogs.perl.org/users/neilb/2017/04/specifying-the-type-of-your-cpan-dependencies.html](https://blogs.perl.org/users/neilb/2017/04/specifying-the-type-of-your-cpan-dependencies.html)
- [https://blogs.perl.org/users/neilb/2017/05/specifying-dependencies-for-your-cpan-distribution.html](https://blogs.perl.org/users/neilb/2017/05/specifying-dependencies-for-your-cpan-distribution.html)

# COPYRIGHT

Copyright © 2026 ryoskzypu

MIT-0 License. See LICENSE for details.
