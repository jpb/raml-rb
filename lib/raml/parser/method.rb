require 'forwardable'
require 'core_ext/hash'
require 'raml/method'
require 'raml/parser/response'
require 'raml/parser/query_parameter'
require 'raml/parser/body'
require 'raml/parser/util'
require 'raml/errors/unknown_attribute_error'

module Raml
  class Parser
    class Method
      extend Forwardable
      include Raml::Parser::Util

      BASIC_ATTRIBUTES = %w[display_name description headers]

      attr_accessor :method, :parent, :attributes
      def_delegators :@parent, :traits

      def initialize(parent)
        @parent = parent
      end

      def parse(the_method, attributes)
        @method = Raml::Method.new(the_method)
        @attributes = prepare_attributes(attributes)

        apply_parents_traits
        apply_traits
        parse_attributes

        method
      end

      private

        def parse_attributes
          attributes.each do |key, value|
            case key
            when *BASIC_ATTRIBUTES
              method.send("#{key}=".to_sym, value)
            when 'responses'
              parse_responses(value)
            when 'query_parameters'
              parse_query_parameters(value)
            when 'body'
              parse_bodies(value)
            else
              raise UnknownAttributeError.new "Unknown method key: #{key}"
            end
          end if attributes
        end

        def parse_responses(responses)
          responses.each do |code, response_attributes|
            method.responses << Raml::Parser::Response.new.parse(code, response_attributes)
          end
        end

        def parse_query_parameters(query_parameters)
          query_parameters.each do |name, parameter_attributes|
            method.query_parameters << Raml::Parser::QueryParameter.new.parse(name, parameter_attributes)
          end
        end

        def parse_bodies(bodies)
          bodies.each do |type, body_attributes|
            method.bodies << Raml::Parser::Body.new.parse(type, body_attributes)
          end
        end

        def apply_parents_traits
          parent.trait_names.each do |name|
            apply_trait(name)
          end if parent.trait_names.respond_to?(:each)
        end

        def apply_traits
          attributes['is'].each do |name|
            apply_trait(name)
          end if attributes['is'].respond_to?(:each)

          attributes.delete('is')
        end

        def apply_trait(name)
          unless traits[name].nil?
            trait_attributes = prepare_attributes(traits[name])
            @attributes = trait_attributes.deep_merge(attributes)
          end
        end

    end
  end
end
