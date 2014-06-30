module Raml
  class Body
    ATTRIBUTES = %w[schema]
    attr_accessor :type, :schema

    def initialize(type)
      @type = type
    end

  end
end
