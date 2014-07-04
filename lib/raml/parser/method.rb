require 'raml/method'
require 'raml/parser/response'
require 'raml/parser/query_parameter'
require 'raml/parser/util'
require 'raml/parser/node'
require 'raml/errors/unknown_attribute_error'

module Raml
  class Parser
    class Method < Node

      BASIC_ATTRIBUTES = %w[description headers]

      attr_accessor :method

      def parse(the_method, data)
        @method = Raml::Method.new(the_method)
        @data = prepare_attributes(data)

        apply_parents_traits
        parse_attributes

        method
      end

      private

        def parse_attributes(attributes = @data)
          attributes.each do |key, value|
            case key
            when *BASIC_ATTRIBUTES
              method.send("#{key}=".to_sym, value)
            when 'is'
              apply_traits(value)
            when 'responses'
              value.each do |code, response_data|
                method.responses << Raml::Parser::Response.new(self).parse(code, response_data)
              end
            when 'query_parameters'
              value.each do |name, parameter_data|
                method.query_parameters << Raml::Parser::QueryParameter.new(self).parse(name, parameter_data)
              end
            else
              raise UnknownAttributeError.new "Unknown method key: #{key}"
            end
          end if attributes
        end

        def apply_parents_traits
          apply_traits(parent.trait_names) if !parent.trait_names.nil? && parent.trait_names.length
        end

        def apply_traits(names)
          names.each do |name|
            apply_trait(name)
          end
        end

        def apply_trait(name)
          unless traits[name].nil?
            trait_data = prepare_attributes(traits[name])
            parse_attributes(trait_data)
          end
        end

    end
  end
end
