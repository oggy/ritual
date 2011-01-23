Feature: Extensions
  Scenario: Building an unnamed extension
    Given I have a gem "my_gem"
    And "Rakefile" contains:
      """
      require 'ritual'
      extension
      """
    And "my_gem.gemspec" contains:
      """
      $:.unshift File.expand_path('lib', File.dirname(__FILE__))
      require '#{name}/version'

      Gem::Specification.new do |s|
        s.name        = 'my_gem'
        s.version     = MyGem::VERSION.to_s
        s.summary     = "I'm just a test gem."
        s.extensions  = ['ext/extconf.rb']
      end
      """
    And "ext/extconf.rb" contains:
      """
      require 'mkmf'
      create_makefile 'my_gem'
      """
    And "ext/my_gem.c" contains:
      """
      #include "ruby.h"
      VALUE MyGem_f(VALUE self) {
        return INT2NUM(5);
      }
      void Init_my_gem(void) {
        rb_define_method(rb_cObject, "f", &MyGem_f, 0);
      }
      """
    When I run "rake ext"
    Then "lib/my_gem/my_gem.DLEXT" should exist

  Scenario: Building a named extension
    Given I have a gem "my_gem"
    And "Rakefile" contains:
      """
      require 'ritual'
      extension :my_ext
      """
    And "my_gem.gemspec" contains:
      """
      $:.unshift File.expand_path('lib', File.dirname(__FILE__))
      require '#{name}/version'

      Gem::Specification.new do |s|
        s.name        = 'my_gem'
        s.version     = MyGem::VERSION.to_s
        s.summary     = "I'm just a test gem."
        s.extensions  = ['ext/my_ext/extconf.rb']
      end
      """
    And "ext/my_ext/extconf.rb" contains:
      """
      require 'mkmf'
      create_makefile 'my_gem/my_ext'
      """
    And "ext/my_ext/my_gem.c" contains:
      """
      #include "ruby.h"
      VALUE MyExt_f(VALUE self) {
        return INT2NUM(5);
      }
      void Init_my_ext(void) {
        rb_define_method(rb_cObject, "f", &MyExt_f, 0);
      }
      """
    When I run "rake ext:my_ext"
    Then "lib/my_gem/my_ext.DLEXT" should exist
