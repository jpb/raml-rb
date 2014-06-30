require 'raml/documentation'
require 'raml/parser/util'
require 'raml/errors/unknown_attribute_error'

module Raml
  class Parser
    class Documentation
      include Raml::Parser::Util

      ATTRIBUTES = BASIC_ATTRIBUTES = %w[title content]

      attr_accessor :root

      def initialize(root)
        @root = root
      end

      def parse_documentation(data)
        documentation << Raml::Documentation.new
        values.each do |key, value|
          key = underscore(key)
          case key
          when *BASIC_ATTRIBUTES
            documentation.send("#{key}=".to_sym, parse_value(value))
          end
        end
        documentation
      end

    end
  end
end
