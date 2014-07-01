module Raml
  class Parser
    module Util

      private

        def set_trait_names(data)
          trait_names = parse_value(data['is'])
          @trait_names = trait_names unless trait_names.nil?
        end

        def apply_parents_traits
          apply_traits(parent.trait_names) if parent.trait_names.length
        end

        def apply_traits(names)
          names.each do |name|
            apply_trait(name)
          end
        end

        def apply_trait(name)
          if root.traits[name]
            data = attributes.select { |key, _| ATTRIBUTES.include?(key) }
            parse_attributes(data)
          end
        end

        def prepare_attributes(data)
          hash = {}
          data.each do |key, value|
            hash[underscore(key)] = parse_value(value)
          end if data.respond_to?(:each)
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
