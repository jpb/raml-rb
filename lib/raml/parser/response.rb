require 'raml/response'
require 'raml/parser/body'
require 'raml/errors/unknown_attribute_error'

module Raml
  class Parser
    class Response < Node

      BASIC_ATTRIBUTES = %w[]
      ATTRIBUTES = BASIC_ATTRIBUTES + %w[body]

      attr_accessor :response

      def parse(code, data)
        @response = Raml::Response.new(code)
        data = prepare_attributes(data)
        set_trait_names(data)
        apply_parents_traits
        parse_attributes(data)
        response
      end

      private

        def parse_attributes(data)
          data.each do |key, value|
            key = underscore(key)
            case key
            when *BASIC_ATTRIBUTES
              response.send("#{key}=".to_sym, parse_value(value))
            when 'is'
              apply_traits(parse_value(value))
            when 'body'
              parse_value(value).each do |type, body_data|
                response.bodies << Raml::Parser::Body.new(self).parse(type, body_data)
              end
            else
              raise UnknownAttributeError.new "Unknown response key: #{key}"
            end
          end
        end

    end
  end
end
