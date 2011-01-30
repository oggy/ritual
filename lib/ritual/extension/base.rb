module Ritual
  module Extension
    class Base
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

        CLEAN.include(compiled_paths)
        CLOBBER.include(@install_path)
      end

      attr_reader :name, :task_name, :path, :build_path, :install_path

      def define_tasks
        raise NotImplementedError, 'abstract'
      end

      protected

      def source_paths
        raise NotImplementedError, 'abstract'
      end

      def compiled_path_for(source_path)
        raise NotImplementedError, 'abstract'
      end

      def compiled_paths
        @compiled_paths ||= source_paths.map { |s| compiled_path_for(s) }
      end

      def relative_path(absolute_path)
        Pathname(absolute_path).relative_path_from(Pathname(path))
      end
    end
  end
end
