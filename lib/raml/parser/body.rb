require 'raml/body'
require 'raml/parser/util'
require 'raml/errors/unknown_attribute_error'

module Raml
  class Parser
    class Body
      include Raml::Parser::Util

      BASIC_ATTRIBUTES = %w[schema example type]
      IGNORED_ATTRIBUTES = %w[properties default]

      attr_accessor :body, :attributes

      def parse(type, attributes)
        @body = Raml::Body.new(type)
        @attributes = prepare_attributes(attributes)

        parse_attributes

        body
      end

      private

        def parse_attributes
          attributes.each do |key, value|
            case key
            when *IGNORED_ATTRIBUTES
              # nothing
            when *BASIC_ATTRIBUTES
              body.send("#{key}=".to_sym, value)
            else
              raise UnknownAttributeError.new "Unknown body key: #{key}"
            end
          end if attributes
        end

    end
  end
end
