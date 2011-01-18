Feature: Installing
  Background:
    Given I have a gem "my_gem" at version "1.2.3"
    And "Rakefile" contains:
      """
      require 'ritual'
      """

  Scenario: Installing the gem
    When I run "rake gem:install"
    Then it should run exactly:
      """
      gem build my_gem.gemspec
      gem install my_gem-1.2.3.gem
      """
