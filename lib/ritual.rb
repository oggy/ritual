require 'date'
require 'fileutils'
require 'ritual/lib'

desc "Select a major version bump."
task :major do
  Ritual.component = 0
end

desc "Select a minor version bump."
task :minor do
  Ritual.component = 1
end

desc "Select a patch version bump."
task :patch do
  Ritual.component = 2
end

desc "Bump the selected version component and do the release ritual."
task :release => %w'repo:bump repo:tag repo:push gem:build gem:push'

namespace :repo do
  desc "Bump and commit the version file and changelog."
  task :bump do
    Ritual.component or
      raise "Please select a version component to bump, e.g.: rake patch release"
    version.increment(Ritual.component)
    changelog.set_latest_version(version)
    version.write
    sh "git add #{version.path} #{changelog.path}"
    sh "git commit #{version.path} #{changelog.path} -m 'Bump to version #{version}.'"
    puts "Bumped to version #{version}."
  end

  desc "Tag the release with the current version."
  task :tag do
    sh "git tag v#{version}"
  end

  desc "Push updates upstream."
  task :push do
    sh "git push origin master"
  end
end

namespace :gem do
  desc "Build the gem."
  task :build do
    sh "gem build #{library_name}.gemspec"
  end

  desc "Push the gem to the gem server."
  task :push do
    sh "gem push #{library_name}-#{version}.gem"
  end

  desc "Install the gem. May require running with sudo."
  task :install => :build do
    sh "gem install #{library_name}-#{version}.gem"
  end
end

def library_name
  Ritual.library_name
end

def version
  @version ||= Ritual.version_file
end

def changelog
  @changelog ||= Ritual.changelog
end

def extensions
  @extensions ||= []
end

def spec_task(*args, &block)
  require 'spec/rake/spectask'
  Spec::Rake::SpecTask.new(*args, &block)
rescue LoadError
end

def cucumber_task(*args, &block)
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(*args, &block)
rescue LoadError
end

def rdoc_task(*args, &block)
  require 'rake/rdoctask'
  Rake::RDocTask.new(*args, &block)
end

def remove_task(name)
  Rake.application.instance_variable_get(:@tasks).delete(name) or
    raise ArgumentError, "task not found: #{name}"
end

def replace_task(name, *args, &block)
  remove_task name
  task(name, *args, &block)
end

def extension(*args)
  options = args.last.is_a?(Hash) ? args.pop : {}
  args.size <= 1 or
    raise ArgumentError, "wrong number of arguments (#{args.size} for 0..1, plus options)"
  return if (gem = options[:gem]) && Ritual.library_name != gem.to_s

  params = options.merge(:library_name => Ritual.library_name)
  klass = params[:type] == :jruby ? Ritual::Extension::JRuby : Ritual::Extension::Standard
  extension = klass.new(args.first, params)
  extensions << extension
  extension.define_tasks
end

module Ritual
  class << self
    attr_accessor :component

    def library_name
      ENV['LIB'] || default_library_name
    end

    def default_library_name
      gemspecs = Dir['*.gemspec']
      names = gemspecs.map{|path| File.basename(path, '.gemspec')}
      if names.size.zero?
        abort "cannot find any gemspecs"
      elsif names.size > 1
        abort "choose a gemspec: LIB=#{names.join('|')}"
      end
      names.first
    end

    def version_file
      @version ||= VersionFile.new("lib/#{library_name}/version.rb", library_name)
    end

    def changelog
      @changelog ||= Changelog.new('CHANGELOG')
    end
  end
end
