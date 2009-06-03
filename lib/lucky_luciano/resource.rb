module LuckyLuciano
  class Resource
    class << self
      def recorded_http_handlers
        @recorded_http_handlers ||= []
      end

      def routes(base_path)
        handlers = recorded_http_handlers
        resource_class = self
        Module.new do
          (class << self; self; end).class_eval do
            define_method(:registered) do |app|
              handlers.each do |handler|
                verb, relative_path, opts, block = handler
                app.send(verb, "#{base_path}#{relative_path.gsub(/\/$/, "")}", opts) do
                  resource_class.new(app).instance_eval(&block)
                end
              end
            end
          end
        end
      end

      ["get", "put", "post", "delete"].each do |http_verb|
        class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
        def #{http_verb}(relative_path, opts={}, &block)
          recorded_http_handlers << [:#{http_verb}, relative_path, opts, block]
        end
        RUBY
      end
    end

    attr_reader :app

    def initialize(app)
      @app = app
    end
  end
end