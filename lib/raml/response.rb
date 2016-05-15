module Raml
  class Response
    attr_accessor :code, :bodies, :description

    def initialize(code)
      @code   = code
      @bodies = []
    end

    def content_types
      bodies.map {|body| body.content_type }.uniq
    end

  end
end
