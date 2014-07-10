module Raml
  class Parser
    module Util

      private

        def prepare_attributes(attributes)
          hash = {}
          attributes.each do |key, value|
            hash[underscore(key)] = value
          end if attributes.respond_to?(:each)
          hash
        end

        def underscore(string)
          string.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
            .gsub(/([a-z\d])([A-Z])/,'\1_\2')
            .downcase
        end

    end
  end
end
