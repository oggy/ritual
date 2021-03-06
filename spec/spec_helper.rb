ROOT = File.dirname(File.dirname(__FILE__))
TMP = "#{ROOT}/features/tmp"

$:.unshift "#{ROOT}/lib"
require 'ritual/lib'

Dir["#{ROOT}/spec/support/*"].each { |path| require path }

RSpec.configure do |config|
  config.include Support::TimeTravel
  config.include Support::TemporaryDirectory

  config.before do
    create_temporary_directory
    stop_time
  end

  config.after do
    destroy_temporary_directory
  end
end
