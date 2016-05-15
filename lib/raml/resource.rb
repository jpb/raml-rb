module Raml
  class Resource
    attr_accessor :parent, :methods, :uri_partial, :resources, :display_name, :description

    def initialize(parent, uri_partial)
      @parent      = parent
      @uri_partial = uri_partial
      @methods     = []
      @resources   = []
    end

    def path
      File.join(parent.path, uri_partial)
    end

    def uri
      File.join(parent.uri, uri_partial)
    end

  end
end
