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

      attr_accessor :root, :parent, :method, :trait_names

      def initialize(root, parent)
        @root = root
        @parent = parent
        @trait_names = []
      end

      def parse(action, data)
        @method = Raml::Method.new(action)
        data = prepare_attributes(data)
        set_trait_names(data)
        apply_parents_traits
        parse_attributes(data)
        method
      end

      private

        def parse_attributes(data)
          data.each do |key, value|
            case key
            when *BASIC_ATTRIBUTES
              method.send("#{key}=".to_sym, parse_value(value))
            when 'is'
              apply_traits(parse_value(value))
            when 'responses'
              parse_value(value).each do |code, response_data|
                method.responses << Raml::Parser::Response.new(root, self).parse(code, response_data)
              end
            when 'query_parameters'
              parse_value(value).each do |name, parameter_data|
                method.query_parameters << Raml::Parser::QueryParameter.new(root, self).parse(name, parameter_data)
              end
            else
              raise UnknownAttributeError.new "Unknown method key: #{key}"
            end
          end if data
        end

    end
  end
end
