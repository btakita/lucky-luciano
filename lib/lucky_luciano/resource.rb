module LuckyLuciano
  class Resource < Module
    class << self
      def recorded_http_handlers
        @recorded_http_handlers ||= []
      end

      ["get", "put", "post", "delete"].each do |http_verb|
        class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
        def #{http_verb}(relative_path, opts={}, &block)
          recorded_http_handlers << [:#{http_verb}, relative_path, opts, block]
        end
        RUBY
      end
    end

    attr_reader :base_path, :name
    def initialize(base_path, name)
      @base_path, @name = base_path, name
    end

    def registered(app)
      self.class.recorded_http_handlers.each do |handler|
        verb, relative_path, opts, block = handler
        me = self
        app.send(verb, "#{base_path}#{relative_path.gsub(/\/$/, "")}", opts) do
          me.instance_eval(&block)
        end
      end
    end

    def path
      base_path
    end
  end
end