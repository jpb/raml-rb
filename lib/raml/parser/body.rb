require 'raml/body'
require 'raml/parser/node'
require 'raml/errors/unknown_attribute_error'

module Raml
  class Parser
    class Body < Node

      BASIC_ATTRIBUTES = %w[schema]

      attr_accessor :body

      def parse(type, data)
        @body = Raml::Body.new(type)
        @data = prepare_attributes(data)

        parse_attributes

        body
      end

      private

        def parse_attributes
          data.each do |key, value|
            case key
            when *BASIC_ATTRIBUTES
              body.send("#{key}=".to_sym, value)
            else
              raise UnknownAttributeError.new "Unknown body key: #{key}"
            end
          end if data
        end

    end
  end
end
