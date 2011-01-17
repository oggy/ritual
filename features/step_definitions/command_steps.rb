require 'shellwords'

# Commands are stubbed out by setting PATH to ./bin, which contains
# scripts that append the command line to commands.log.

When /^I run "(.*)"$/ do |command|
  # Run through Ritual's bundler, so rake etc. can be found.
  output = `BUNDLE_GEMFILE=#{ROOT}/Gemfile bundle exec #{command} 2>&1`
  $?.success? or
    raise "command failed: #{command}\nOutput:\n#{output}"
end

Then /^it should run:/ do |commands|
  # Massage quotes out of commands, as we can't test these.
  commands = commands.map do |command|
    words = Shellwords.shellwords(command)
    words.join(' ') << "\n"
  end.join

  FileUtils.touch 'commands.log'
  File.read('commands.log').should == commands
end
