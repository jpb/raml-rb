require 'forwardable'
require 'raml/resource'
require 'raml/parser/method'
require 'raml/parser/node'
require 'raml/errors/unknown_attribute_error'

module Raml
  class Parser
    class Resource < Node
      extend Forwardable

      METHODS = %w[get put post delete]

      attr_accessor :parent_node, :resource, :trait_names
      def_delegators :@parent_node, :resources

      def parse(parent_node, uri_partial, attribute)
        @parent_node = parent_node
        @resource = Raml::Resource.new(@parent_node, uri_partial)
        @attribute = prepare_attributes(attribute)
        parse_attributes
        resource
      end

      private

        def parse_attributes
          attribute.each do |key, value|
            key = underscore(key)
            case key
            when /^\//
              resources << Raml::Parser::Resource.new(self).parse(resource, key, value)
            when *METHODS
              resource.methods << Raml::Parser::Method.new(self).parse(key, value)
            when 'is'
              @trait_names = value
            else
              raise UnknownAttributeError.new "Unknown resource key: #{key}"
            end
          end if attribute
        end

    end
  end
end
