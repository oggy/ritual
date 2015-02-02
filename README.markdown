# Ritual [![Build Status](https://travis-ci.org/oggy/ritual.png?branch=master)](https://travis-ci.org/oggy/ritual) [![Gem Version](https://badge.fury.io/rb/ritual.svg)](http://badge.fury.io/rb/ritual)

Sweet, simple Rakefiles for your gem.

Picks up where Bundler leaves off, reducing the entire release ritual
to a single command.

## Example

For a plain ruby gem (no extensions), this is usually enough for your
`Rakefile`:

    require 'ritual'

To release a new patch version of your gem:

    rake patch release

The `release` task just runs these tasks:

    rake repo:bump    # Bump and commit the version file and changelog.
    rake repo:tag     # Tag the release with the current version.
    rake repo:push    # Push updates upstream.
    rake gem:build    # Build the gem.
    rake gem:push     # Push the gem to the gem server.

Select which component to bump with one of these:

    rake patch        # Select a patch version bump.
    rake minor        # Select a minor version bump.
    rake major        # Select a major version bump.

For example:

 * `rake patch release` will bump 1.2.3 to 1.2.4 and release.
 * `rake minor release` will bump 1.2.3 to 1.3.0 and release.
 * `rake major release` will bump 1.2.3 to 2.0.0 and release.

"Release early, release often" has never been so easy!

## Getting Started

Got an existing project?

    ritual apply

Starting a new one?

    ritual new GEM-NAME

## Gemspec

You [maintain the gemspec directly][using-gemspecs-as-intended], rather than via
a wrapper like Jeweler or Hoe.

[using-gemspecs-as-intended]: http://yehudakatz.com/2010/04/02/using-gemspecs-as-intended

## Version File

The version file lives at `lib/gem_name/version.rb` (`gem_name`
matches the name of the gemspec). It contains a line that looks like:

    VERSION = [1, 2, 3]

When bumping the version, Ritual will only alter this line in the
file. You may have any custom code around this line.

## Changelog

The changelog lives at `CHANGELOG`. When bumping the version, it will
look for a line like:

    == LATEST

And replace it with the new version and current date:

    == 1.2.3 2011-09-01

If it can't find this line, the version bump will fail. This prevents
you from releasing without a changelog update.

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

    create_makefile "my_gem/my_gem"

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

### JRuby extensions

JRuby doesn't support extensions in the traditional sense (using
`mkmf`). Instead, you typically build a `.jar` which is packaged into
the gem.

To build a JRuby extension, pass `:type => :jruby` to
`extension`. JRuby extensions can be named or unnamed, as above. All
`.java` files are fed to `javac` simultanously to build the `.jar`,
which is bundled into the gem by `gem:build`.

## Note on Patches/Pull Requests
 
 * Bug reports: http://github.com/oggy/ritual/issues
 * Source: http://github.com/oggy/ritual
 * Patches: Fork on Github, send pull request.
   * Ensure patch includes tests.
   * Leave the version alone, or bump it in a separate commit.

## Copyright

Copyright (c) George Ogata. See LICENSE for details.
