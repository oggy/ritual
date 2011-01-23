Given /^I have a gem "(.*?)"(?: at version "(.*?)")?$/ do |name, version|
  @gem_name = name
  version ||= '0.0.0'
  camelized_name = camelize(name)

  make_file 'Rakefile', ''

  make_file 'Gemfile', <<-EOS
    |gemspec
  EOS

  make_file "#{name}.gemspec", <<-EOS
    |$:.unshift File.expand_path('lib', File.dirname(__FILE__))
    |require '#{name}/version'
    |
    |Gem::Specification.new do |s|
    |  s.name        = '#{name}'
    |  s.version     = #{camelized_name}::VERSION.to_s
    |  s.summary     = "I'm just a test gem."
    |end
  EOS

  make_file "CHANGELOG", <<-EOS
    |== LATEST
    |== #{version} #{Date.today.strftime('%Y-%m-%d')}
  EOS

  make_file "lib/#{name}.rb", <<-EOS
    |module #{camelized_name}
    |end
  EOS

  make_file "lib/#{name}/version.rb", <<-EOS
    |module #{camelized_name}
    |  VERSION = [#{version.gsub(/\./, ', ')}]
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

Given /^"(.*?)" contains:$/ do |file_name, content|
  make_file file_name, content
end

Then /^the version should be "(.*?)"$/ do |version|
  version_file = "lib/#{@gem_name}/version.rb"
  eval "module TEMP_CONTEXT\n#{File.read(version_file)}\nend", nil, version_file, 0
  begin
    actual = TEMP_CONTEXT.const_get(camelize(@gem_name))::VERSION
    actual.to_s.should == version
  ensure
    Object.send(:remove_const, :TEMP_CONTEXT)
  end
end

Then /^the latest changelog version should be "(.*?)"$/ do |version|
  File.read('CHANGELOG') =~ /^== (\S+) /
  $1.should == version
end

Then /^"(.*?)" should contain:$/ do |file_name, content|
  File.read(file_name).chomp.should == content.chomp
end

Then /^"(.*?)" should exist$/ do |file_name|
  file_name.gsub!(/DLEXT/, Config::CONFIG['DLEXT'])
  File.should exist(file_name)
end
