module Raml
  class Method
    ATTRIBUTES = ['description', 'headers', 'queryParameters']

    attr_accessor :action, :description, :headers, :responses, :queryParameters

    def initialize(action)
      @action = action
      @responses = []
    end

  end
end
