require 'raml/response'
require 'raml/parser/util'
require 'raml/parser/body'
require 'raml/errors/unknown_attribute_error'

module Raml
  class Parser
    class Response
      include Raml::Parser::Util

      attr_accessor :response, :attributes

      def parse(code, attributes)
        @response = Raml::Response.new(code)
        @attributes = prepare_attributes(attributes)
        parse_attributes
        response
      end

      private

        def parse_attributes
          attributes.each do |key, value|
            key = underscore(key)
            case key
            when 'body'
              parse_bodies(value)
            when 'description'
              response.description = value
            else
              raise UnknownAttributeError.new "Unknown response key: #{key}"
            end
          end if attributes
        end

        def parse_bodies(bodies)
          bodies.each do |type, body_attributes|
            response.bodies << Raml::Parser::Body.new.parse(type, body_attributes)
          end
        end

    end
  end
end
