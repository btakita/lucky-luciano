module LuckyLuciano
  class Resource
    class << self
      def register(path)
        me = self
        get path do
          me.new(self).get
        end

        post path do
          me.new(self).post
        end

        put path do
          me.new(self).put
        end

        delete path do
          me.new(self).delete
        end
      end
    end

    include Sinatra

    attr_reader :request
    def initialize(request)
      @request = request
    end

    def get
      raise NotFound
    end

    def put
      raise NotFound
    end

    def post
      raise NotFound
    end

    def delete
      raise NotFound
    end

    protected

    def params; request.params; end
  end
end