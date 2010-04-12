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

 * `spec_task(*args, &block)`: Define a spec task. Noop if RSpec cannot be
   loaded.
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

## Note on Patches/Pull Requests
 
 * Bug reports: http://github.com/oggy/ritual/issues
 * Source: http://github.com/oggy/ritual
 * Patches: Fork on Github, send pull request.
   * Ensure patch includes tests.
   * Leave the version alone, or bump it in a separate commit.

## Copyright

Copyright (c) 2010 George Ogata. See LICENSE for details.
