Given /^debug$/ do
  if (RUBY_ENGINE rescue nil) == 'rbx'
    require 'rubinius/debugger'
    Rubinius::Debugger.start
  else
    require 'ruby-debug'
    debugger
  end
  nil
end
