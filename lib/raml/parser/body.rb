require 'raml/body'
require 'raml/parser/util'
require 'raml/errors/unknown_attribute_error'

module Raml
  class Parser
    class Body
      include Raml::Parser::Util
      ATTRIBUTES = BASIC_ATTRIBUTES = %w[schema]

      attr_accessor :root, :parent, :body, :trait_names

      def initialize(root, parent)
        @root = root
        @parent = parent
        @trait_names = []
      end

      def parse(type, data)
        @body = Raml::Body.new(type)
        data = prepare_attributes(data)
        set_trait_names(data)
        apply_parents_traits
        parse_attributes(data)
        body
      end

      private

        def parse_attributes(data)
          data.each do |key, value|
            case key
            when *BASIC_ATTRIBUTES
              body.send("#{key}=".to_sym, value)
            when 'is'
              apply_traits(value)
            else
              raise UnknownAttributeError.new "Unknown body key: #{key}"
            end
          end if data
        end

    end
  end
end
