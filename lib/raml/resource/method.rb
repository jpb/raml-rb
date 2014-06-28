module Raml
  class Resource
    class Method
      ATTRIBUTES = ['description', 'headers']

      attr_accessor :action, :description, :headers, :responses

      def initilize(action)
        @action = action
      end

    end
  end
end
