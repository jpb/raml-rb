require 'forwardable'
require 'raml/parser/util'

module Raml
  class Parser
    class Node
      include Raml::Parser::Util
      extend Forwardable

      attr_accessor :parent, :data
      def_delegators :@parent, :traits

      def initialize(parent)
        @parent = parent
      end

    end
  end
end
