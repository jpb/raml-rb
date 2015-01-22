module Raml
  class Response
    attr_accessor :code, :bodies, :description

    def initialize(code)
      @code = code
      @bodies = []
    end

    def content_types
      [].tap do |types|
        bodies.each do |body|
          types << body.content_type
        end
      end.uniq
    end

  end
end
