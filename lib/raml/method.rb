module Raml
  class Method

    attr_accessor :method, :description, :headers, :responses,
                  :query_parameters, :bodies, :display_name

    def initialize(method)
      @method = method
      @responses = []
      @query_parameters = []
      @bodies = []
    end

    def response_codes
      responses.map {|responses| response.code }
    end

    def content_types
      responses.map {|response| response.content_type }.flatten.uniq
    end

  end
end
