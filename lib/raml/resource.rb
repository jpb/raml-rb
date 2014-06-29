module Raml
  class Resource
    ATTRIBUTES = []
    attr_accessor :parent, :resources, :methods, :uri_partial

    def initialize(parent, uri_partial)
      @parent = parent
      @uri_partial = uri_partial
      @resources = []
      @methods = []
    end

    def url
      File.join(parent.uri, uri_partial)
    end

  end
end
