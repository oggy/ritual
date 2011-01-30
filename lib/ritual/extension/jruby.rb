module Ritual
  module Extension
    class JRuby < Base
      def define_task
        task 'gem:build' => task_name
        desc "Build the #{name} extension."
        task task_name do
          relative_install_path = relative_path(install_path)
          relative_compiled_paths = compiled_paths.map { |p| relative_path(p) }
          class_path = "#{Config::CONFIG['prefix']}/lib/jruby.jar"

          sh 'javac', '-g', '-classpath', class_path, *source_paths
          Dir.chdir path do
            mkdir_p File.dirname(relative_install_path)
            sh 'jar', 'cf', relative_install_path, *relative_compiled_paths
          end
        end
      end

      def source_paths
        @source_paths ||= FileList["#{path}/**/*.java"]
      end

      protected

      def compiled_path_for(source)
        source.sub(/\.java\z/, '.class')
      end
    end
  end
end
