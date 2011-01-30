require 'rbconfig'
require 'pathname'
require 'rake/clean'

module Ritual
  module Extension
    autoload :Base, 'ritual/extension/base'
    autoload :JRuby, 'ritual/extension/jruby'
    autoload :Standard, 'ritual/extension/standard'
  end
end
