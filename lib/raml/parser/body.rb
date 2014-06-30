require 'raml/body'
require 'raml/parser/util'
require 'raml/errors/unknown_attribute_error'

module Raml
  class Parser
    class Body
      include Raml::Parser::Util
      ATTRIBUTES = BASIC_ATTRIBUTES = %w[schema]

      attr_accessor :root

      def initialize(root)
        @root = root
      end

      def parse(type, data)
        body = Raml::Body.new(type)
        parse_attributes(body, data)
      end

      private

        def parse_attributes(body, data)
          data.each do |key, value|
            key = underscore(key)
            case key
            when *BASIC_ATTRIBUTES
              body.send("#{key}=".to_sym, parse_value(value))
            when 'is'
              value = value.is_a?(Array) ? value : [value]
              value.each do |name|
                unless root.traits[name].nil?
                  body = parse_attributes(body, root.traits[name])
                end
              end
            else
              raise UnknownAttributeError.new "Unknown body key: #{key}"
            end
          end if data

          body
        end

    end
  end
end
