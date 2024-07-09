require 'rspec'
require 'rack/test'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

def app
  Application
end
