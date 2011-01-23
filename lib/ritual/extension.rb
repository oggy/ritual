require 'rbconfig'
require 'pathname'

module Ritual
  class Extension
    DLEXT = Config::CONFIG['DLEXT']

    def initialize(name, params={})
      @name = name ? name.to_sym : nil
      library_name = params[:library_name]

      build_path = params[:build_as] and
        @build_path = "#{build_path}.#{DLEXT}"
      install_path = params[:install_as] and
        @install_path = "#{install_path}.#{DLEXT}"

      if name
        @task_name = "ext:#{name}"
        @path = params[:path] || "ext/#{name}"
        @build_path ||= "#{path}/#{name}.#{DLEXT}"
        @install_path ||= "lib/#{library_name}/#{name}.#{DLEXT}"
      else
        @task_name = 'ext'
        @path = params[:path] || 'ext'
        @build_path ||= "#{path}/#{library_name}.#{DLEXT}"
        @install_path ||= "lib/#{library_name}/#{library_name}.#{DLEXT}"
      end
    end

    attr_reader :name, :task_name, :path, :build_path, :install_path

    def build
      relative_build_path = relative_path(build_path)
      relative_install_path = relative_path(install_path)
      Dir.chdir path do
        ruby 'extconf.rb'
        sh(RUBY_PLATFORM =~ /win32/ ? 'nmake' : 'make')
        mkdir_p File.dirname(relative_install_path)
        sh "cp #{relative_build_path} #{relative_install_path}"
      end
    end

    def clean
      Dir["#{path}/**/*.o"].each { |f| FileUtils.rm_f f }
    end

    private

    def relative_path(absolute_path)
      Pathname(absolute_path).relative_path_from(Pathname(path))
    end
  end
end
