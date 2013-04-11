require 'rubygems'
require 'spork'

Spork.prefork do
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
  $LOAD_PATH.unshift(File.dirname(__FILE__))
  require 'rspec'
  require 'sticky_fingers'

  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

  def sample_file(filename)
    File.expand_path "sample/#{filename}", File.dirname(__FILE__)
  end

  RSpec.configure do |config|

  end
end

Spork.each_run do
end



