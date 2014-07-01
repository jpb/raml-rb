require 'raml/resource'
require 'raml/parser/method'
require 'raml/parser/util'
require 'raml/errors/unknown_attribute_error'

module Raml
  class Parser
    class Resource
      include Raml::Parser::Util

      BASIC_ATTRIBUTES = ATTRIBUTES = %w[]

      attr_accessor :root, :parent, :root_node, :parent_node, :resource, :trait_names

      def initialize(root, parent)
        @root = root
        @parent = parent
        @trait_names = []
      end

      def parse(parent_node, root_node, uri_partial, data)
        @parent_node = parent_node
        @root_node = root_node
        @resource = Raml::Resource.new(parent, uri_partial)
        data = prepare_attributes(data)
        set_trait_names(data)
        apply_parents_traits
        parse_attributes(data)
        @resource
      end

      private

        def parse_attributes(data)
          data.each do |key, value|
            key = underscore(key)
            case key
            when *BASIC_ATTRIBUTES
              resource.send("#{key}=".to_sym, parse_value(value))
            when 'is'
              apply_traits(parse_value(value))
            when /^\//
              root_node.resources << Raml::Parser::Resource.new(root, self).parse(resource, root_node, key, parse_value(value))
            when *%w(get put post delete)
              resource.methods << Raml::Parser::Method.new(root, self).parse(key, parse_value(value))
            else
              raise UnknownAttributeError.new "Unknown resource key: #{key}"
            end
          end
        end

    end
  end
end
