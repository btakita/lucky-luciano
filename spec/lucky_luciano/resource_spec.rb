require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module LuckyLuciano
  module ResourceSpec
    class ResourceFixture < Resource
      def get
        "He sleeps with the fishes"
      end
    end
  end
  
  describe Resource do
    describe ".register" do
      it "registers get, post, put, and delete actions on the passed-in path" do
        path = "/foobar"
        mock.proxy(Sinatra::Base).get(path)
        mock.proxy(Sinatra::Base).put(path)
        mock.proxy(Sinatra::Base).post(path)
        mock.proxy(Sinatra::Base).delete(path)

        ResourceSpec::ResourceFixture.register("/foobar")
      end

      describe "#get, #put, #post, #delete (all actions pretty much act the same, to this is the examplar)" do
        context "when the method is defined on the Resource" do
          it "responds with a 200 and the return-value of the method" do
            ResourceSpec::ResourceFixture.register("/foobar")
            response = get("/foobar")
            response.status.should == 200
            response.body.should include("He sleeps with the fishes")
          end
        end

        context "when the method is not defined on the Resource" do
          it "responds with a 404" do
            ResourceSpec::ResourceFixture.register("/foobar")
            response = post("/foobar")
            response.status.should == 404
          end
        end
      end
    end
  end
end
