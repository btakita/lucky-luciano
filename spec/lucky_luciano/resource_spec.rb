require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module LuckyLuciano
  module ResourceSpec
    class ResourceFixture < Resource
      map "/foobar"
    end

    describe Resource do
      include ResourceSpec

      macro("responds to") do |verb|
        describe ".#{verb}" do
          before do
            ResourceFixture.send(verb, "/") do
              "He sleeps with the fishes"
            end
          end

          it "creates a route to #{verb.upcase} the given path that executes the given block" do
            response = send(verb, "/foobar")
            response.status.should == 200
            response.body.should include("He sleeps with the fishes")
          end

          it "does not respond to another type of http request" do
            get("/foobar").status.should == 404 unless verb == "get"
            put("/foobar").status.should == 404 unless verb == "put"
            post("/foobar").status.should == 404 unless verb == "post"
            delete("/foobar").status.should == 404 unless verb == "delete"
          end
        end
      end

      send("responds to", "get")
      send("responds to", "put")
      send("responds to", "post")
      send("responds to", "delete")
    end
  end
  
end
