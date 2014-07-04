require 'raml/documentation'
require 'raml/parser/node'
require 'raml/errors/unknown_attribute_error'

module Raml
  class Parser
    class Documentation < Node

      ATTRIBUTES = BASIC_ATTRIBUTES = %w[title content]

      attr_accessor :documentation

      def parse(data)
        @documentation = Raml::Documentation.new

        data = prepare_attributes(data)
        parse_attributes(data)

        documentation
      end

      private

        def parse_attributes(data)
          data.each do |key, value|
            case key
            when *BASIC_ATTRIBUTES
              documentation.send("#{key}=".to_sym, value)
            else
              raise UnknownAttributeError.new "Unknown documentation key: #{key}"
            end
          end
        end

    end
  end
end
