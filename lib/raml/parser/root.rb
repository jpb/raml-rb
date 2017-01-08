require 'raml/root'
require 'raml/parser/resource'
require 'raml/parser/documentation'
require 'raml/parser/util'
require 'raml/errors/unknown_attribute_error'

module Raml
  class Parser
    class Root
      include Raml::Parser::Util

      BASIC_ATTRIBUTES = %w[title base_uri version base_uri_parameters media_type secured_by security_schemes types schemas]

      attr_accessor :root, :traits, :resource_types, :attributes

      def initialize
        @traits = {}
        @resource_types = {}
      end

      def parse(attributes)
        @root = Raml::Root.new
        @attributes = prepare_attributes(attributes)
        parse_attributes
        root
      end

      private

        def parse_attributes
          attributes.each do |key, value|
            key = underscore(key)
            case key
            when *BASIC_ATTRIBUTES
              root.send("#{key}=".to_sym, value)
            when 'traits'
              parse_traits(value)
            when 'resource_types'
              parse_resource_types(value)
            when 'documentation'
              parse_documentation(value)
            when /^\//
              root.resources << Raml::Parser::Resource.new(self).parse(root, key, value)
            else
              raise UnknownAttributeError.new "Unknown root key: #{key}"
            end
          end if attributes
        end

        def parse_documentation(documentations)
          documentations.each do |documentation_attributes|
            root.documentation << Raml::Parser::Documentation.new.parse(documentation_attributes)
          end
        end

        def parse_resource_types(resource_types)
          resource_types.each do |type|
            type.each do |name, type_attributes|
              @resource_types[name] = type_attributes
            end
          end
        end

        def parse_traits(traits)
          traits.each do |trait|
            trait.each do |name, trait_attributes|
              @traits[name] = trait_attributes
            end
          end
        end
    end
  end
end
