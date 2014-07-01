require 'forwardable'

module Raml
  class Parser
    module Traitable
      extend Forwardable
      attr_accessor :parent, :trait_names
      def_delegators :@parent, :traits

        private

          def set_trait_names(data)
            trait_names = parse_value(data['is'])
            @trait_names = trait_names unless trait_names.nil?
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
            if traits[name]
              data = attributes.select { |key, _| ATTRIBUTES.include?(key) }
              parse_attributes(data)
            end
          end

    end
  end
end
