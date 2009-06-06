require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module LuckyLuciano
  module ResourceSpec
    class ResourceFixture < Resource
      map "/foobar"
    end

    class ResourceFixtureWithSubPaths < Resource
      map "/foobar"

      get "/baz" do
        "Response from /foobar/baz"
      end
    end

    describe Resource do
      include ResourceSpec

      before do
        ResourceFixture.recorded_http_handlers.clear
      end

      macro("http verb") do |verb|
        describe ".#{verb}" do
          it "creates a route to #{verb.upcase} the given path that executes the given block" do
            ResourceFixture.send(verb, "/") do
              "He sleeps with the fishes"
            end
            app.register(ResourceFixture.route_handler)
            response = send(verb, "/foobar")
            response.status.should == 200
            response.body.should include("He sleeps with the fishes")
          end

          it "does not respond to another type of http request" do
            ResourceFixture.send(verb, "/") do
              ""
            end
            app.register(ResourceFixture.route_handler)
            get("/foobar").status.should == 404 unless verb == "get"
            put("/foobar").status.should == 404 unless verb == "put"
            post("/foobar").status.should == 404 unless verb == "post"
            delete("/foobar").status.should == 404 unless verb == "delete"
          end

          it "evaluates the block in as a Resource" do
            evaluation_target = nil
            ResourceFixture.send(verb, "/") do
              evaluation_target = self
              ""
            end
            app.register(ResourceFixture.route_handler)

            send(verb, "/foobar")
            evaluation_target.class.should == ResourceFixture
          end
        end
      end

      send("http verb", "get")
      send("http verb", "put")
      send("http verb", "post")
      send("http verb", "delete")

      describe ".path" do
        context "when passed nothing" do
          it "returns the base_path" do
            ResourceFixture.path.should == "/foobar"
          end
        end
        
        context "when passed a sub path" do
          it "merges the base_path into the sub path, regardless of a / in front" do
            ResourceFixtureWithSubPaths.path("/baz").should == "/foobar/baz"
            ResourceFixtureWithSubPaths.path("baz").should == "/foobar/baz"
          end
        end
      end
    end
  end
  
end
