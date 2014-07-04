module Raml
  class Parser
    module Util

      private

        def prepare_attributes(attributes)
          hash = {}
          attributes.each do |key, value|
            hash[underscore(key)] = parse_value(value)
          end if attributes.respond_to?(:each)
          hash
        end

        def parse_value(value)
          if value.is_a?(String) && value.strip.start_with?('include!')
            File.read value.match(/include!(.*)/)[1].strip
          else
            value
          end
        end

        def underscore(string)
          string.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
            .gsub(/([a-z\d])([A-Z])/,'\1_\2')
            .tr('-', '_')
            .downcase
        end

    end
  end
end
