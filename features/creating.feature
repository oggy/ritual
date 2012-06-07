Feature: Creating

  Scenario: Creating a new gem
    When I run "ritual new my_gem"
    Then "my_gem/.gitignore" should contain:
      """
      /Gemfile.lock
      """
    Then "my_gem/Gemfile" should contain:
      """
      source :rubygems
      gemspec
      """
    And "my_gem/Rakefile" should contain:
      """
      require 'ritual'
      """
    And "my_gem/CHANGELOG" should contain:
      """
      == LATEST

       * Hi.
      """
    And "my_gem/README.markdown" should contain:
      """
      ## My Gem
      """
    And "my_gem/LICENSE" should contain:
      """
      Copyright (c) AUTHOR

      Permission is hereby granted, free of charge, to any person obtaining
      a copy of this software and associated documentation files (the
      "Software"), to deal in the Software without restriction, including
      without limitation the rights to use, copy, modify, merge, publish,
      distribute, sublicense, and/or sell copies of the Software, and to
      permit persons to whom the Software is furnished to do so, subject to
      the following conditions:

      The above copyright notice and this permission notice shall be
      included in all copies or substantial portions of the Software.

      THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
      EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
      MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
      NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
      LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
      OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
      WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
      """
    And "my_gem/lib/my_gem.rb" should contain:
      """
      module MyGem
        autoload :VERSION, 'my_gem/version'
      end
      """
    And "my_gem/lib/my_gem/version.rb" should contain:
      """
      module MyGem
        VERSION = [0, 0, 0]

        class << VERSION
          include Comparable

          def to_s
            join('.')
          end
        end
      end
      """
    And "my_gem/my_gem.gemspec" should contain:
      """
      # -*- encoding: utf-8 -*-
      $:.unshift File.expand_path('lib', File.dirname(__FILE__))
      require 'my_gem/version'

      Gem::Specification.new do |gem|
        gem.name          = 'my_gem'
        gem.version       = MyGem::VERSION
        gem.authors       = ['AUTHOR']
        gem.email         = ['EMAIL']
        gem.license       = 'MIT'
        gem.description   = "TODO: Write a gem description"
        gem.summary       = "TODO: Write a gem summary"
        gem.homepage      = ''

        gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
        gem.files         = `git ls-files`.split("\n")
        gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

        gem.add_development_dependency 'ritual', '~> VERSION'
      end
      """
