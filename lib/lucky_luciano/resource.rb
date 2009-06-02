module LuckyLuciano
  class Resource
    class << self
      attr_accessor :path
      def map(path)
        self.path = path
      end

      ["get", "put", "post", "delete"].each do |http_verb|
        class_eval(<<-EVAL, __FILE__, __LINE__ + 1)
        def #{http_verb}(relative_path, opts={}, &block)
          me = self
          full_path = (path + relative_path).gsub(Regexp.new("/$", ""), "")
          super(full_path, opts) do
            me.new(self).instance_eval(&block)
          end
        end
        EVAL
      end
    end

    include Sinatra

    attr_reader :application
    def initialize(application)
      @application = application
    end

    protected

    def params; application.params; end
  end
end