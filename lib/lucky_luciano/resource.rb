module LuckyLuciano
  class Resource < Module
    class << self
      attr_accessor :path
      def map(path)
        self.path = path
      end

      def recorded_http_handlers
        @recorded_http_handlers ||= []
      end

      ["get", "put", "post", "delete"].each do |http_verb|
        class_eval(<<-EVAL, __FILE__, __LINE__ + 1)
        def #{http_verb}(relative_path, opts={}, &block)
          recorded_http_handlers << [:#{http_verb}, relative_path, opts, block]
        end
        EVAL
      end
    end

    def registered(app)
      self.class.recorded_http_handlers.each do |handler|
        verb, relative_path, opts, block = handler
        me = self
        app.send(verb, "#{self.class.path}#{relative_path.gsub(/\/$/, "")}", opts) do
          me.instance_eval(&block)
        end
      end
    end
  end
end