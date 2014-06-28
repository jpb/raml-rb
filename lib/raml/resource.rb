require 'uri'

module Raml
  class Definition
    class Resource
      attr_accessor :parent, :resources, :methods, :uri_partial

      def initialize(parent, uri_partial)
        @parent = parent
        @uri_partial = uri_partial
        @resources = []
        @methods = []
      end

      def url
        URI.join(parent.uri, uri_partial)
      end

    end
  end
end
