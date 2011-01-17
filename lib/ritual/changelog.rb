module Ritual
  class Changelog
    Error = Class.new(RuntimeError)

    def initialize(path)
      @path = path
    end

    attr_reader :path

    def set_latest_version(version)
      File.exist?(path) or
        raise Error, "Don't release without a CHANGELOG!"
      text = File.read(path)
      heading = "#{version} #{Date.today.strftime('%Y-%m-%d')}"
      text.sub!(/^(== )LATEST$/i, "\\1#{heading}") or
        raise Error, "No LATEST entry in CHANGELOG - did you forget to update it?"
      open(path, 'w'){|f| f.print text}
    end
  end
end
