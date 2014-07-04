require 'raml/documentation'
require 'raml/errors/unknown_attribute_error'

module Raml
  class Parser
    class Documentation
      include Raml::Parser::Util

      BASIC_ATTRIBUTES = %w[title content]

      attr_accessor :documentation, :attributes

      def parse(attributes)
        @documentation = Raml::Documentation.new
        @attributes = prepare_attributes(attributes)

        parse_attributes

        documentation
      end

      private

        def parse_attributes
          attributes.each do |key, value|
            case key
            when *BASIC_ATTRIBUTES
              documentation.send("#{key}=".to_sym, value)
            else
              raise UnknownAttributeError.new "Unknown documentation key: #{key}"
            end
          end if attributes
        end

    end
  end
end
