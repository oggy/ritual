# -*- encoding: utf-8 -*-
$:.unshift File.expand_path('lib', File.dirname(__FILE__))
require 'ritual/version'

Gem::Specification.new do |s|
  s.name        = 'ritual'
  s.date        = Date.today.strftime('%Y-%m-%d')
  s.version     = Ritual::VERSION.join('.')
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["George Ogata"]
  s.email       = ["george.ogata@gmail.com"]
  s.homepage    = "http://github.com/oggy/ritual"
  s.summary     = "Rakefile release tasks and helpers."
  s.description = <<-EOS.gsub(/^ *\|/, '')
    |Adds tasks and helpers to your Rakefile to manage releases in a
    |lightweight manner.
  EOS

  s.required_rubygems_version = ">= 1.3.6"
  s.files = Dir["lib/**/*"] + %w(LICENSE README.markdown Rakefile CHANGELOG)
  s.require_path = 'lib'
  s.specification_version = 3
end
