require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

describe Sinatra do
  module SinatraSpec
    class ResourceFixture < LuckyLuciano::Resource
    end
  end

  describe ".resource" do
    it "registers the passed-in Resource, which registers get, put, post, and delete on Sinatra" do
      path = "/foobar"

      mock.proxy(SinatraSpec::ResourceFixture).register(path)
      
      mock.proxy(Sinatra::Base).get(path)
      mock.proxy(Sinatra::Base).put(path)
      mock.proxy(Sinatra::Base).post(path)
      mock.proxy(Sinatra::Base).delete(path)

      Sinatra.send(:resource, "/foobar", SinatraSpec::ResourceFixture)
    end
  end
end
