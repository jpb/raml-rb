module Raml
  class Resource
    ATTRIBUTES = %w[]
    attr_accessor :parent, :methods, :uri_partial

    def initialize(parent, uri_partial)
      @parent = parent
      @uri_partial = uri_partial
      @methods = []
    end

    def uri
      File.join(parent.uri, uri_partial)
    end

  end
end
