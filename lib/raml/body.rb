module Raml
  class Body
    attr_accessor :content_type, :schema, :example, :type

    def initialize(content_type)
      @content_type = content_type
    end

  end
end
