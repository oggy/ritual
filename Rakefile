$:.unshift File.expand_path('lib', File.dirname(__FILE__))
require 'ritual'

task :ci do
  sh 'bundle exec rspec -I. spec'

  if defined?(RUBY_ENGINE) && RUBY_ENGINE == 'jruby'
    sh 'bundle exec cucumber --tags=~@ext'
  else
    sh 'bundle exec cucumber --tags=~@jruby'
  end
end
