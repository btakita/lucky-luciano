module Sinatra
  module Resource
    def resource(path, resource_class)
      resource_class.register(path)
    end
  end
  register Resource
end
