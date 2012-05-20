require 'shellwords'

# Commands are stubbed out by setting PATH to ./bin, which contains
# scripts that append the command line to commands.log.

When /^I run "(.*)"$/ do |command|
  # Run through Ritual's bundler, so rake etc. can be found.
  @output = `BUNDLE_GEMFILE=#{ROOT}/Gemfile bundle exec #{command} 2>&1`
  @output.gsub!(/\e\[(.*?)m/, '')  # remove terminal escapes
  $?.success? or
    raise "command failed: #{command}\nOutput:\n#{@output}"
end

When /^I try to run "(.*)"$/ do |command|
  # Run through Ritual's bundler, so rake etc. can be found.
  @output = `BUNDLE_GEMFILE=#{ROOT}/Gemfile bundle exec #{command} 2>&1`
  !$?.success? or
    raise "command succeeded: #{command}\nOutput:\n#{@output}"
end

Then /^it should output "(.*?)"$/ do |output|
  @output.should include(output)
end

Then /^it should run exactly:/ do |commands|
  commands = commands.split(/\n/).map do |command|
    words = Shellwords.shellwords(command)
    words.join(' ') << "\n"
  end.join
  commands_run.join.should == commands
end

Then /^it should run "(.*?)"$/ do |command|
  found = commands_run.any? do |line|
    command == line.chomp
  end
  found or
    raise "Command not run: #{command}\nCommands run:\n#{commands_run.join.gsub(/^/, '  ')}"
end

Then /^it should not run "(.*?)"$/ do |command|
  found = commands_run.any? do |line|
    command == line.chomp
  end
  found and
    raise "Command run: #{command}\nCommands run:\n#{commands_run.join.gsub(/^/, '  ')}"
end

Then /^it should not run any commands$/ do
  File.should_not exist('commands.log')
end
