module Ritual
  class VersionFile
    def initialize(path, library_name)
      @path = path
      @library_name = library_name
      @value ||= read
    end

    attr_reader :path, :library_name, :value

    def to_s
      value.join('.')
    end

    def write
      FileUtils.mkdir_p File.dirname(path)
      open(path, 'w') do |file|
        file.puts <<-EOS.gsub(/^ *\|/, '')
          |module #{module_name}
          |  VERSION = #{value.inspect}
          |
          |  class << VERSION
          |    include Comparable
          |
          |    def to_s
          |      join('.')
          |    end
          |  end
          |end
        EOS
      end
    end

    def increment(component)
      (value.size..component).each{|i| value[i] = 0}
      value[component] += 1
      (component+1 ... value.size).each{|i| value[i] = 0}
    end

    private

    def read
      if File.exist?(path)
        File.read(path) =~ /^\s*VERSION\s*=\s*(\[.*?\])/ and
          eval $1
      else
        [0, 0, 0]
      end
    end

    def module
      Object.const_defined?(module_name) or
        Object.const_set(module_name, Module.new)
      Object.const_get(module_name)
    end

    def module_name
      library_name.gsub(/(?:\A|_)(.)/){$1.upcase}
    end
  end
end
