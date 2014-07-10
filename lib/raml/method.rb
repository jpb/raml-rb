module Raml
  class Method

    attr_accessor :method, :description, :headers, :responses, :query_parameters

    def initialize(method)
      @method = method
      @responses = []
      @query_parameters = []
    end

    def response_codes
      [].tap do |codes|
        responses.each do |response|
          codes << response.code
        end
      end
    end

    def content_types
      [].tap do |types|
        responses.each do |response|
          types << response.content_types
        end
      end.flatten.uniq
    end

  end
end
