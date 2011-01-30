module Ritual
  module Extension
    class Standard < Base
      def define_task
        desc "Build the #{name} extension."
        task task_name do
          relative_build_path = relative_path(build_path)
          relative_install_path = relative_path(install_path)
          Dir.chdir path do
            ruby 'extconf.rb'
            sh(RUBY_PLATFORM =~ /win32/ ? 'nmake' : 'make')
            mkdir_p File.dirname(relative_install_path)
            sh "cp #{relative_build_path} #{relative_install_path}"
          end
        end
      end

      def source_paths
        @sources ||= Dir["#{path}/**/*.{c,cxx,cpp,C}"]
      end

      protected

      def compiled_path_for(source)
        source.sub(/\.c(?:pp|xx)?\z/i, '.o')
      end
    end
  end
end
