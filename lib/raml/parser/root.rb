require 'raml/root'
require 'raml/parser/resource'
require 'raml/parser/documentation'
require 'raml/parser/util'
require 'raml/errors/unknown_attribute_error'

module Raml
  class Parser
    class Root
      include Raml::Parser::Util

      BASIC_ATTRIBUTES = %w[title base_uri version]

      attr_accessor :root, :traits, :resource_types, :attribute

      def initialize
        @traits = {}
      end

      def parse(attribute)
        @root = Raml::Root.new
        @attribute = prepare_attributes(attribute)
        parse_attributes
        root
      end

      private

        def parse_attributes
          attribute.each do |key, value|
            key = underscore(key)
            case key
            when *BASIC_ATTRIBUTES
              root.send("#{key}=".to_sym, value)
            when 'traits'
              parse_traits(value)
            when 'documentation'
              parse_documentation(value)
            when /^\//
              root.resources << Raml::Parser::Resource.new(self).parse(root, key, value)
            else
              raise UnknownAttributeError.new "Unknown root key: #{key}"
            end
          end if attribute
        end

        def parse_documentation(documentations)
          documentations.each do |documentation_attribute|
            root.documentations << Raml::Parser::Documentation.new(self).parse(documentation_attribute)
          end
        end

        def parse_traits(traits)
          traits.each do |trait|
            trait.each do |name, trait_attribute|
              @traits[name] = trait_attribute
            end
          end
        end

    end
  end
end
