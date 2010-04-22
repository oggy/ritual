require 'fileutils'

desc "Build and install the gem."
task :install => %w'ritual:build ritual:install_gem'

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
task :release => %w'ritual:check_release_args ritual:bump ritual:tag ritual:push ritual:build ritual:push_gem'

# Private helper tasks.
namespace :ritual do
  task :check_release_args do
    Ritual.component or
      raise "Please select a version component to bump, e.g.: rake patch release"
  end

  task :bump do
    version.increment(Ritual.component)
    version.write
    sh "git add #{version.path}"
    sh "git commit #{version.path} -m 'Bump to version #{version}.'"
    puts "Bumped to version #{version}."
  end

  task :tag do
    sh "git tag v#{version}"
  end

  task :push do
    sh "git push origin master"
  end

  task :build do
    sh "gem build #{library_name}.gemspec"
  end

  task :push_gem do
    sh "gem push #{library_name}-#{version}.gem"
  end

  task :install_gem do
    sh "gem install #{library_name}-#{version}.gem"
  end
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
  end

  class Version
    def initialize(library_name)
      @library_name = library_name
      @value ||= read
    end

    attr_reader :value, :library_name

    def to_s
      value.join('.')
    end

    def read
      if File.exist?(path)
        load path
        self.module::VERSION
      else
        self.module.const_set(:VERSION, [0, 0, 0])
      end
    end

    def write
      FileUtils.mkdir_p File.dirname(path)
      open(path, 'w') do |file|
        file.puts "module #{module_name}\n  VERSION = #{value.inspect}\nend"
      end
    end

    def increment(component)
      value[component] += 1
      (component+1 ... value.size).each{|i| value[i] = 0}
    end

    def path
      "lib/#{library_name}/version.rb"
    end

    def module_name
      library_name.gsub(/(?:\A|_)(.)/){$1.upcase}
    end

    def module
      Object.const_defined?(module_name) or
        Object.const_set(module_name, Module.new)
      Object.const_get(module_name)
    end
  end
end

#
# Global API
#

def library_name
  Ritual.library_name
end

def version
  @version ||= Ritual::Version.new(library_name)
end

def spec_task(*args, &block)
  require 'spec/rake/spectask'
  Spec::Rake::SpecTask.new(*args, &block)
rescue LoadError
end

def rdoc_task(*args, &block)
  require 'rake/rdoctask'
  Rake::RDocTask.new(*args, &block)
end
