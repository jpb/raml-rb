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

      attr_accessor :root, :traits, :data

      def initialize
        @traits = {}
      end

      def parse(data)
        @root = Raml::Root.new
        @data = prepare_attributes(data)
        parse_attributes
        root
      end

      private

        def parse_attributes
          data.each do |key, value|
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
          end if data
        end

        def parse_documentation(documentations)
          documentations.each do |documentation_data|
            root.documentations << Raml::Parser::Documentation.new(self).parse(documentation_data)
          end
        end

        def parse_traits(traits)
          traits.each do |trait|
            trait.each do |name, trait_data|
              @traits[name] = trait_data
            end
          end
        end

    end
  end
end
