require 'raml/response'
require 'raml/parser/body'
require 'raml/errors/unknown_attribute_error'

module Raml
  class Parser
    class Response < Node

      attr_accessor :response

      def parse(code, attribute)
        @response = Raml::Response.new(code)
        @attribute = prepare_attributes(attribute)
        parse_attributes
        response
      end

      private

        def parse_attributes
          attribute.each do |key, value|
            key = underscore(key)
            case key
            when 'body'
              parse_bodies(value)
            else
              raise UnknownAttributeError.new "Unknown response key: #{key}"
            end
          end if attribute
        end

        def parse_bodies(bodies)
          bodies.each do |type, body_attribute|
            response.bodies << Raml::Parser::Body.new(self).parse(type, body_attribute)
          end
        end

    end
  end
end
