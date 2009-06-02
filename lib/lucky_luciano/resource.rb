module LuckyLuciano
  class Resource
    class << self
      attr_accessor :path
      def map(path)
        self.path = path
      end

      def get(relative_path, opts={}, &block)
        super("#{path}#{relative_path}".gsub(/\/$/, ""), opts, &block)
      end

      def put(relative_path, opts={}, &block)
        super("#{path}#{relative_path}".gsub(/\/$/, ""), opts, &block)
      end

      def post(relative_path, opts={}, &block)
        super("#{path}#{relative_path}".gsub(/\/$/, ""), opts, &block)
      end

      def delete(relative_path, opts={}, &block)
        super("#{path}#{relative_path}".gsub(/\/$/, ""), opts, &block)
      end
    end

    include Sinatra

    attr_reader :request
    def initialize(request)
      @request = request
    end

    protected

    def params; request.params; end
  end
end