module Ritual
  module Extension
    class Standard < Base
      MAKE = RUBY_PLATFORM =~ /win32/ ? 'nmake' : 'make'

      def define_tasks
        desc "Build the #{name} extension."
        task task_name do
          relative_build_path = relative_path(build_path)
          relative_install_path = relative_path(install_path)
          Dir.chdir path do
            ruby 'extconf.rb'
            sh MAKE
            mkdir_p File.dirname(relative_install_path)
            sh "cp #{relative_build_path} #{relative_install_path}"
          end
        end

        task :clean do
          if File.exist?("#{path}/Makefile")
            Dir.chdir path do
              sh MAKE, 'clean'
              rm 'Makefile'
            end
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
