module Raml
  class Response
    ATTRIBUTES = []
    attr_accessor :code, :bodies

    def initialize(code)
      @code = code
      @bodies = []
    end

  end
end
