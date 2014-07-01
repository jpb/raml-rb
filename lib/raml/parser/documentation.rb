require 'raml/documentation'
require 'raml/parser/util'
require 'raml/errors/unknown_attribute_error'

module Raml
  class Parser
    class Documentation
      include Raml::Parser::Util

      ATTRIBUTES = BASIC_ATTRIBUTES = %w[title content]

      attr_accessor :root, :parent, :documentation, :trait_names

      def initialize(root, parent)
        @root = root
        @parent = parent
        @trait_names = []
      end

      def parse(data)
        @documentation = Raml::Documentation.new
        data = prepare_attributes(data)
        set_trait_names(data)
        apply_parents_traits
        parse_attributes(data)
        documentation
      end

      def parse_attributes(data)
        data.each do |key, value|
          case key
          when *BASIC_ATTRIBUTES
            documentation.send("#{key}=".to_sym, value)
          when 'is'
            apply_traits(value)
          end
        end
      end

    end
  end
end
