require 'raml/method'
require 'raml/parser/response'
require 'raml/parser/query_parameter'
require 'raml/parser/util'
require 'raml/errors/unknown_attribute_error'

module Raml
  class Parser
    class Method
      include Raml::Parser::Util

      ATTRIBUTES = BASIC_ATTRIBUTES = %w[description headers]

      attr_accessor :root

      def initialize(root)
        @root = root
      end

      def parse(action, data)
        method = Raml::Method.new(action)
        parse_attributes(method, data)
      end

      private

        def parse_attributes(method, data)
          data.each do |key, value|
            key = underscore(key)
            case key
            when *BASIC_ATTRIBUTES
              method.send("#{key}=".to_sym, parse_value(value))
            when 'is'
              value = value.is_a?(Array) ? value : [value]
              value.each do |name|
                unless root.traits[name].nil?
                  method = parse_attributes(method, root.traits[name])
                end
              end
            when 'responses'
              parse_value(value).each do |code, response_data|
                method.responses << Raml::Parser::Response.new(root).parse(code, response_data)
              end
            when 'query_parameters'
              parse_value(value).each do |name, parameter_data|
                method.query_parameters << Raml::Parser::QueryParameter.new(root).parse(name, parameter_data)
              end
            else
              raise UnknownAttributeError.new "Unknown method key: #{key}"
            end
          end if data

          method
        end

    end
  end
end
