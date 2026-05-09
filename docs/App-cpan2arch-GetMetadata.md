# NAME

App::cpan2arch::GetMetadata - get CPAN metadata from MetaCPAN's API

# SYNOPSIS

```perl
use App::cpan2arch;

my $cpan2arch = App::cpan2arch->new;

...
```

# DESCRIPTION

This role handles the fetching of module/distribution metadata from
[MetaCPAN's](https://github.com/metacpan/metacpan-api) API.

# METHODS

## get\_metadata

```perl
$cpan2arch->get_metadata;
```

Takes no arguments and returns `0` on success.

# BUGS

Report bugs at [https://github.com/ryoskzypu/App-cpan2arch/issues](https://github.com/ryoskzypu/App-cpan2arch/issues).

# AUTHOR

ryoskzypu <ryoskzypu@proton.me>

# SEE ALSO

- [https://blogs.perl.org/users/neilb/2016/12/working-with-the-metacpan-api.html](https://blogs.perl.org/users/neilb/2016/12/working-with-the-metacpan-api.html)

# COPYRIGHT

Copyright © 2026 ryoskzypu

MIT-0 License. See LICENSE for details.
