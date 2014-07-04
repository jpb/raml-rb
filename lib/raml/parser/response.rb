require 'raml/response'
require 'raml/parser/body'
require 'raml/errors/unknown_attribute_error'

module Raml
  class Parser
    class Response < Node

      attr_accessor :response

      def parse(code, data)
        @response = Raml::Response.new(code)
        @data = prepare_attributes(data)
        parse_attributes
        response
      end

      private

        def parse_attributes
          data.each do |key, value|
            key = underscore(key)
            case key
            when 'body'
              parse_bodies(value)
            else
              raise UnknownAttributeError.new "Unknown response key: #{key}"
            end
          end if data
        end

        def parse_bodies(bodies)
          bodies.each do |type, body_data|
            response.bodies << Raml::Parser::Body.new(self).parse(type, body_data)
          end
        end

    end
  end
end
