require 'forwardable'
require 'raml/parser/util'

module Raml
  class Parser
    class Node
      include Raml::Parser::Util
      extend Forwardable

      attr_accessor :parent, :trait_names
      def_delegators :@parent, :traits

      def initialize(parent)
        @parent = parent
        @trait_names = []
      end

      private

        def set_trait_names(data)
          names = data['is'] || []
          names = names + parent.trait_names unless parent.trait_names.nil?
          @trait_names = names
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
            data = prepare_attributes(traits[name])
            data = data.select { |key, _| self.class::ATTRIBUTES.include?(key) || !(key =~ /^\//).nil? }
            parse_attributes(data)
          end
        end

    end
  end
end
