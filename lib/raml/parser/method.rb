require 'raml/method'
require 'raml/parser/response'
require 'raml/parser/query_parameter'
require 'raml/parser/util'
require 'raml/parser/node'
require 'raml/errors/unknown_attribute_error'

module Raml
  class Parser
    class Method < Node

      BASIC_ATTRIBUTES = %w[description headers]
      ATTRIBUTES = BASIC_ATTRIBUTES + %w[responses query_parameters]

      attr_accessor :method

      def parse(the_method, data)
        @method = Raml::Method.new(the_method)
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
                method.responses << Raml::Parser::Response.new(self).parse(code, response_data)
              end
            when 'query_parameters'
              parse_value(value).each do |name, parameter_data|
                method.query_parameters << Raml::Parser::QueryParameter.new(self).parse(name, parameter_data)
              end
            else
              raise UnknownAttributeError.new "Unknown method key: #{key}"
            end
          end if data
        end

    end
  end
end
