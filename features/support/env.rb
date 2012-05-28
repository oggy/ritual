require 'fileutils'
require 'rspec/expectations'

ROOT = File.dirname(File.dirname(File.dirname(__FILE__)))
TMP = "#{ROOT}/features/tmp"

ORIGINAL_PATH = ENV['PATH']

Before do
  FileUtils.mkdir_p(TMP)
  @original_pwd = Dir.pwd
  Dir.chdir TMP

  ENV['RUBYLIB'] = "#{ROOT}/lib"
  ENV['PATH'] = "#{ROOT}/bin:#{TMP}/bin"
  ENV['RITUAL_AUTHOR'] = "AUTHOR"
  ENV['RITUAL_EMAIL'] = "EMAIL"
  ENV['RITUAL_VERSION'] = "VERSION"
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
    unstub_command 'cp'
    case (RUBY_ENGINE rescue nil)
    when 'jruby'
      unstub_command 'jruby'
      unstub_command 'javac'
      unstub_command 'jar'
    when 'rbx'
      unstub_command 'rbx'
    when 'ruby'
      unstub_command 'ruby'
      unstub_command 'ruby_noexec_wrapper' if RUBY_VERSION >= '1.9.3'
    else
      unstub_command 'ruby'
    end
    stub_command 'git'
    stub_command 'gem'
    use_real_environment_for 'make'
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

  def use_real_environment_for(name)
    open("bin/#{name}", 'w') do |file|
      file.puts <<-EOS.gsub(/^ *\|/, '')
        |#!/bin/sh
        |exec /usr/bin/env PATH="#{ORIGINAL_PATH}" #{name} "\$@"
      EOS
    end
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
