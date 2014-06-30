require 'raml/resource'
require 'raml/parser/method'
require 'raml/parser/util'
require 'raml/errors/unknown_attribute_error'

module Raml
  class Parser
    class Resource
      include Raml::Parser::Util

      BASIC_ATTRIBUTES = ATTRIBUTES = %w[]

      attr_accessor :root, :parent

      def initialize(root, parent)
        @root = root
        @parent = parent
      end

      def parse(parent, uri_partial, data)
        resource = Raml::Resource.new(parent, uri_partial)
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
                unless parent.traits[name].nil?
                  resource = parse_attributes(resource, parent.traits[name])
                end
              end
            when /^\//
              root.resources << Raml::Parser::Resource.new(root, self).parse(resource, key, parse_value(value))
            when *%w(get put post delete)
              resource.methods << Raml::Parser::Method.new(self).parse(key, parse_value(value))
            else
              raise UnknownAttributeError.new "Unknown resource key: #{key}"
            end
          end

          resource
        end

    end
  end
end
