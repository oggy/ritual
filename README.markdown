# Ritual

Adds tasks and helpers to your Rakefile to manage releases.

Much more lightweight than [Jeweler][jeweler] or [Newgem][newgem]. Way less
flexible, as it's only geared towards my workflow so far.

Like the idea? Feel free to fork and send patches!

[jeweler]: http://github.com/technicalpickles/jeweler
[newgem]: http://github.com/drnic/newgem

## Usage

In `Rakefile`:

    gem 'ritual'
    require 'ritual'

Adds some shortcuts:

 * `cucumber_task(*args, &block)`: Define a Cucumber task. Noop if
   Cucumber cannot be loaded.
 * `spec_task(*args, &block)`: Define an RSpec task. Noop if RSpec
   cannot be loaded.
 * `rdoc_task(*args, &block)`: Define an rdoc task.

And some tasks:

 * `rake major release` 
 * `rake minor release` 
 * `rake patch release` 
   * Perform the release ritual:
     * Bump the major/minor/patch version. This is defined in
       `lib/<library-name>/version.rb.`
     * Tag the release in git.
     * Push the git repo to origin.
     * Build the gem from the gemspec.
     * Push the gem to Gemcutter.

You [maintain the gemspec directly][using-gemspecs-as-intended], rather than via
a wrapper like Jeweler or Hoe.

[using-gemspecs-as-intended]: http://yehudakatz.com/2010/04/02/using-gemspecs-as-intended

## Extensions

Use `extension` to define an extension-building task. Use one of two
conventions.

### Unnamed extensions

If you only need a single extension, say if you're simply wrapping a C
library, then use an unnamed extension. In your Rakefile, do:

    extension

This defines a task `ext` to build your extension. Source files live
in `ext/`, and the extension is named after the gem.

So if the gem is `my_gem`, then Ritual configures your extension with
`ext/extconf.rb`, runs `make`, and installs `ext/my_gem.DLEXT` to
`lib/my_gem/my_gem.DLEXT`. (`DLEXT` is the shared library extension,
which varies from system to system.) `extconf.rb` should contain:

    create_makefile "my_gem"

And the extension entry point is `Init_my_gem`.

### Named extensions

If you need more than one extension, you better name them. Do:

    extension :my_ext

The task is named `ext:my_ext`. Source files live in
`ext/my_ext/`. Ritual configures the extension with
`ext/my_ext/extconf.rb`, and installs `ext/my_ext/my_gem.DLEXT` to
`lib/my_gem/my_ext.DLEXT`. `extconf.rb`, should contain:

    create_makefile "my_gem/my_ext"

And the extension entry point is `Init_my_ext`.

### Customizing

Both `extension` calls above can take options:

 * `:build_as` - The path of the shared library that gets built.
 * `:install_as` - The path the shared library is installed to.

Both are relative to the Rakefile's directory, and should omit the
shared library extension.

## Note on Patches/Pull Requests
 
 * Bug reports: http://github.com/oggy/ritual/issues
 * Source: http://github.com/oggy/ritual
 * Patches: Fork on Github, send pull request.
   * Ensure patch includes tests.
   * Leave the version alone, or bump it in a separate commit.

## Copyright

Copyright (c) 2010 George Ogata. See LICENSE for details.
