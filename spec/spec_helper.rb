require "rubygems"
require "spec"
require "spec/autorun"
require 'rack/test'
require "rr"

dir = File.dirname(__FILE__)
$:.unshift File.expand_path("#{dir}/../lib")
require "lucky_luciano"

set :environment, :test

class Spec::ExampleGroup
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
end

Spec::Runner.configure do |config|
  config.mock_with :rr
end
