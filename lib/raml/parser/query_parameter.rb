require 'raml/query_parameter'
require 'raml/parser/util'
require 'raml/errors/unknown_attribute_error'

module Raml
  class Parser
    class QueryParameter
      include Raml::Parser::Util

      BASIC_ATTRIBUTES = ATTRIBUTES = %w[description type example]

      attr_accessor :parent

      def initialize(parent)
        @parent = parent
      end

      def parse(name, data)
        query_parameter = Raml::QueryParameter.new(name)
        parse_attributes(query_parameter, data)
      end

      private

        def parse_attributes(query_parameter, data)
          data.each do |key, value|
            key = underscore(key)
            case key
            when *BASIC_ATTRIBUTES
              query_parameter.send("#{key}=".to_sym, parse_value(value))
            when 'is'
              value = value.is_a?(Array) ? value : [value]
              value.each do |name|
                unless parent.traits[name].nil?
                  body = parse_query_paramter_attributes(query_parameter, parent.traits[name])
                end
              end
            else
              raise UnknownAttributeError.new "Unknown query paramter key: #{key}"
            end
          end if data

          query_parameter
        end

    end
  end
end
