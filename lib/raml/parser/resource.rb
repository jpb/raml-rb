require 'forwardable'
require 'core_ext/hash'
require 'raml/resource'
require 'raml/parser/method'
require 'raml/parser/util'
require 'raml/errors/unknown_attribute_error'

module Raml
  class Parser
    class Resource
      extend Forwardable
      include Raml::Parser::Util

      HTTP_METHODS = %w[get put post delete]

      attr_accessor :parent_node, :resource, :trait_names, :attributes
      def_delegators :@parent, :traits, :resource_types

      def initialize(parent)
        @parent = parent
      end

      def parse(parent_node, uri_partial, attributes)
        @parent_node = parent_node
        @resource = Raml::Resource.new(@parent_node, uri_partial)
        @attributes = prepare_attributes(attributes)
        apply_resource_type
        parse_attributes
        resource
      end

      private

        def parse_attributes
          attributes.each do |key, value|
            key = underscore(key)
            case key
            when /^\//
              resource.resources << Raml::Parser::Resource.new(self).parse(resource, key, value)
            when *HTTP_METHODS
              resource.http_methods << Raml::Parser::Method.new(self).parse(key, value)
            when 'is'
              @trait_names = value
            else
              raise UnknownAttributeError.new "Unknown resource key: #{key}"
            end
          end if attributes
        end

        def apply_resource_type
          name = attributes['type']
          if name and !resource_types[name].nil?
            resource_attributes = prepare_attributes(resource_types[name])
            @attributes.delete('type')
            @attributes = resource_attributes.deep_merge(attributes)
          end
        end

    end
  end
end
