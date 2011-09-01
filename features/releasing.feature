Feature: Releasing
  Background:
    Given I have a gem "my_gem" at version "1.2.3"
    And "Rakefile" contains:
      """
      require 'ritual'
      """

  Scenario: Releasing a patch version of a gem
    When I run "rake patch release"
    Then it should run exactly:
      """
      git add lib/my_gem/version.rb CHANGELOG
      git commit lib/my_gem/version.rb CHANGELOG -m 'Bump to version 1.2.4.'
      git tag v1.2.4
      git push origin master tags/v1.2.4
      gem build my_gem.gemspec
      gem push my_gem-1.2.4.gem
      """
    And the version should be "1.2.4"
    And the latest changelog version should be "1.2.4"

  Scenario: Releasing a minor version of a gem
    When I run "rake minor release"
    Then the version should be "1.3.0"

  Scenario: Releasing a minor version of a gem
    When I run "rake major release"
    Then the version should be "2.0.0"

  Scenario: Failing to specify a component to bump
    When I try to run "rake release"
    Then it should output "Please select a version component to bump"
    And it should not run any commands
    And the version should be "1.2.3"
    And the latest changelog version should be "1.2.3"

  Scenario: The version file is invalid
    When the version file "lib/my_gem/version.rb" is invalid
    And I try to run "rake patch release"
    Then it should output "invalid version file: lib/my_gem/version.rb"
    And it should not run any commands
