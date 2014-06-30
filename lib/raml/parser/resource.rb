require 'raml/resource'
require 'raml/parser/method'
require 'raml/parser/util'
require 'raml/errors/unknown_attribute_error'

module Raml
  class Parser
    class Resource
      include Raml::Parser::Util

      BASIC_ATTRIBUTES = ATTRIBUTES = %w[]

      attr_accessor :root_node, :root

      def initialize(root_node, root)
        @root_node = root_node
        @root = root
      end

      def parse(root, uri_partial, data)
        resource = Raml::Resource.new(root, uri_partial)
        parse_attributes(resource, data)
      end

      private

        def parse_attributes(resource, data)
          data.each do |key, value|
            key = underscore(key)
            case key
            when *BASIC_ATTRIBUTES
              resource.send("#{key}=".to_sym, parse_value(value))
            when 'is'
              value = value.is_a?(Array) ? value : [value]
              value.each do |name|
                unless root.traits[name].nil?
                  resource = parse_attributes(resource, root.traits[name])
                end
              end
            when /^\//
              root_node.resources << Raml::Parser::Resource.new(root_node, root).parse(resource, key, parse_value(value))
            when *%w(get put post delete)
              resource.methods << Raml::Parser::Method.new(root).parse(key, parse_value(value))
            else
              raise UnknownAttributeError.new "Unknown resource key: #{key}"
            end
          end

          resource
        end

    end
  end
end
