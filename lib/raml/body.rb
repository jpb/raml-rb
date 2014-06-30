module Raml
  class Body
    attr_accessor :type, :schema

    def initialize(type)
      @type = type
    end

  end
end
