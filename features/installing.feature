Feature: Installing
  Background:
    Given I have a gem "my_gem" at version "1.2.3"
    And I have a Rakefile containing:
      """
      require 'ritual'
      """

  Scenario: Installing the gem
    When I run "rake install"
    And it should run:
      """
      gem build my_gem.gemspec
      gem install my_gem-1.2.3.gem
      """
