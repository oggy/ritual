Feature: Customization
  Scenario: Customizing repo:bump
    Given I have a gem "mygem" at version "1.2.3"
    And "Rakefile" contains:
      """
      require 'ritual'

      replace_task 'repo:bump' do
        sh 'git CUSTOMIZED_BUMP'
      end
      """
    When I run "rake patch release"
    Then it should run "git CUSTOMIZED_BUMP"
    And it should not run "git add lib/my_gem/version.rb CHANGELOG"
    And it should not run "git commit lib/my_gem/version.rb CHANGELOG -m 'Bump to version 1.2.4.'"
    And the version should be "1.2.3"
    And the latest changelog version should be "1.2.3"

  Scenario: Customizing repo:tag
    Given I have a gem "mygem" at version "1.2.3"
    And "Rakefile" contains:
      """
      require 'ritual'

      replace_task 'repo:tag' do
        sh 'git CUSTOMIZED_TAG'
      end
      """
    When I run "rake patch release"
    Then it should run "git CUSTOMIZED_TAG"
    And it should not run "git tag v1.2.4"

  Scenario: Customizing repo:push
    Given I have a gem "mygem" at version "1.2.3"
    And "Rakefile" contains:
      """
      require 'ritual'

      replace_task 'repo:push' do
        sh 'git CUSTOMIZED_PUSH'
      end
      """
    When I run "rake patch release"
    Then it should run "git CUSTOMIZED_PUSH"
    And it should not run "git push origin master"

  Scenario: Customizing gem:build
    Given I have a gem "mygem" at version "1.2.3"
    And "Rakefile" contains:
      """
      require 'ritual'

      replace_task 'gem:build' do
        sh 'git CUSTOMIZED_BUILD_GEM'
      end
      """
    When I run "rake patch release"
    Then it should run "git CUSTOMIZED_BUILD_GEM"
    And it should not run "gem build my_gem.gemspec"

  Scenario: Customizing gem:push
    Given I have a gem "mygem" at version "1.2.3"
    And "Rakefile" contains:
      """
      require 'ritual'

      replace_task 'gem:push' do
        sh 'git CUSTOMIZED_PUSH_GEM'
      end
      """
    When I run "rake patch release"
    Then it should run "git CUSTOMIZED_PUSH_GEM"
    And it should not run "gem push my_gem-1.2.4.gem"

  Scenario: Customizing gem:install
    Given I have a gem "mygem" at version "1.2.3"
    And "Rakefile" contains:
      """
      require 'ritual'

      replace_task 'gem:install' do
        sh 'gem CUSTOMIZED_INSTALL'
      end
      """
    When I run "rake gem:install"
    Then it should run "gem CUSTOMIZED_INSTALL"
    And it should not run "gem install my_gem-1.2.3.gem"

  Scenario: Customizing the wrong rake task
    Given I have a gem "mygem" at version "1.2.3"
    And "Rakefile" contains:
      """
      require 'ritual'

      replace_task 'wrong' do
      end
      """
    When I try to run "rake install"
    Then it should output "task not found: wrong"

  Scenario: Customizing the version file
    Given I have a gem "mygem" at version "1.2.3"
    And "Rakefile" contains:
      """
      require 'ritual'
      """
    And "lib/mygem/version.rb" contains:
      """
      module Mygem
        VERSION=[1,2,3]
        CUSTOM_STUFF_HERE
      end
      """
    When I run "rake patch repo:bump"
    Then "lib/mygem/version.rb" should contain:
      """
      module Mygem
        VERSION = [1, 2, 4]
        CUSTOM_STUFF_HERE
      end
      """
