module Raml
  class Method

    attr_accessor :method, :description, :headers, :responses, :query_parameters

    def initialize(method)
      @method = method
      @responses = []
      @query_parameters = []
    end

  end
end
