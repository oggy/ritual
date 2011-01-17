require 'date'
require 'fileutils'
require 'ritual/lib'

desc "Build and install the gem."
task :install => %w'ritual:build_gem ritual:install_gem'

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
task :release => %w'ritual:check_release_args ritual:bump ritual:tag ritual:push ritual:build_gem ritual:push_gem'

# Private helper tasks.
namespace :ritual do
  task :check_release_args do
    Ritual.component or
      raise "Please select a version component to bump, e.g.: rake patch release"
  end

  task :bump do
    version.increment(Ritual.component)
    changelog.set_latest_version(version)
    version.write
    sh "git add #{version.path} #{changelog.path}"
    sh "git commit #{version.path} #{changelog.path} -m 'Bump to version #{version}.'"
    puts "Bumped to version #{version}."
  end

  task :tag do
    sh "git tag v#{version}"
  end

  task :push do
    sh "git push origin master"
  end

  task :build_gem do
    sh "gem build #{library_name}.gemspec"
  end

  task :push_gem do
    sh "gem push #{library_name}-#{version}.gem"
  end

  task :install_gem do
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
      path = "lib/#{library_name}/version.rb"
      VersionFile.new(path, library_name)
    end

    def changelog
      Changelog.new('CHANGELOG')
    end
  end
end
