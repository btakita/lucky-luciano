require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module LuckyLuciano
  module ResourceSpec
    class ResourceFixture < Resource
      map "/foobar"
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
    end
  end
  
end
