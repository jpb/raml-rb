require 'raml/query_parameter'
require 'raml/parser/node'
require 'raml/errors/unknown_attribute_error'

module Raml
  class Parser
    class QueryParameter < Node

      BASIC_ATTRIBUTES = %w[description type example]

      attr_accessor :query_parameter

      def parse(name, attribute)
        @query_parameter = Raml::QueryParameter.new(name)

        @attribute = prepare_attributes(attribute)
        parse_attributes(attribute)

        query_parameter
      end

      private

        def parse_attributes(attribute)
          attribute.each do |key, value|
            key = underscore(key)
            case key
            when *BASIC_ATTRIBUTES
              query_parameter.send("#{key}=".to_sym, value)
            else
              raise UnknownAttributeError.new "Unknown query paramter key: #{key}"
            end
          end if attribute
        end

    end
  end
end
