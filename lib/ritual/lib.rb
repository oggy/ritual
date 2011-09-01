require 'fileutils'

module Ritual
  Error = Class.new(RuntimeError)
  autoload :Changelog, 'ritual/changelog'
  autoload :Extension, 'ritual/extension'
  autoload :VersionFile, 'ritual/version_file'
  autoload :VERSION, 'ritual/version'
end
