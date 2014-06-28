module Raml
  class Response
    class Method
      class Response
        class Body
          attr_accessor :type, :schema

          def initialize(type)
            @type = type
          end

        end
      end
    end
  end
end
