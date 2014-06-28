module Raml
  class Resource
    class Method
      class Response
        attr_accessor :code, :bodies

        def initialize(code)
          @code = code
        end

      end
    end
  end
end
