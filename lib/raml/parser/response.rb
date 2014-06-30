require 'raml/response'
require 'raml/parser/body'
require 'raml/parser/util'
require 'raml/errors/unknown_attribute_error'

module Raml
  class Parser
    class Response
      include Raml::Parser::Util

      BASIC_ATTRIBUTES = ATTRIBUTES = %w[]

      attr_accessor :parent

      def initialize(parent)
        @parent = parent
      end

      def parse(code, data)
        response = Raml::Response.new(code)
        parse_attributes(response, data)
      end

      private

        def parse_attributes(response, data)
          data.each do |key, value|
            key = underscore(key)
            case key
            when *BASIC_ATTRIBUTES
              response.send("#{key}=".to_sym, parse_value(value))
            when 'is'
              value = value.is_a?(Array) ? value : [value]
              value.each do |name|
                unless traits[name].nil?
                  response = parse_attributes(response, traits[name])
                end
              end
            when 'body'
              parse_value(value).each do |type, body_data|
                response.bodies << Raml::Parser::Body.new(self).parse(type, body_data)
              end
            else
              raise UnknownAttributeError.new "Unknown response key: #{key}"
            end
          end

          response
        end

    end
  end
end
