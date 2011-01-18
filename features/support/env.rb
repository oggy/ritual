require 'fileutils'
require 'spec/expectations'
require 'ruby-debug'

ROOT = File.dirname(File.dirname(File.dirname(__FILE__)))
TMP = "#{ROOT}/features/tmp"

ORIGINAL_PATH = ENV['PATH']

Debugger.start

Before do
  FileUtils.mkdir_p(TMP)
  @original_pwd = Dir.pwd
  Dir.chdir TMP

  ENV['RUBYLIB'] = 'lib'
  ENV['PATH'] = 'bin'
  setup_path
end

After do
  Dir.chdir @original_pwd
  FileUtils.rm_rf(TMP)
end

module RitualWorld
  def setup_path
    FileUtils.mkdir_p 'bin'
    unstub_command 'bundle'
    unstub_command 'basename'
    stub_command 'git'
    stub_command 'gem'
  end

  def unstub_command(name)
    ORIGINAL_PATH.split(/:/).each do |dir|
      next if dir.strip.empty?
      path = "#{dir}/#{name}"
      if File.file?(path)
        File.symlink path, "bin/#{name}"
        return
      end
    end
    raise "cannot find `#{name}' command - ensure it's in your PATH and try again"
  end

  def stub_command(name)
    FileUtils.cp "#{ROOT}/features/support/capture", "bin/#{name}"
    File.chmod 0755, "bin/#{name}"
  end

  def make_file(path, content)
    content = content.gsub(/^ *\|/, '')
    FileUtils.mkdir_p File.dirname(path)
    open(path, 'w'){|f| f.print content}
  end

  def camelize(string)
    string.gsub(/(?:\A|_)(.)/){$1.upcase}
  end

  def commands_run
    path = 'commands.log'
    File.exist?(path) ? File.readlines(path) : []
  end
end

World RitualWorld
