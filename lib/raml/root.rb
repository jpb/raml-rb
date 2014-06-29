module Raml
  class Root
    ATTRIBUTES = %w[
      title
      baseUri
      version
    ]
    attr_accessor :title, :baseUri, :version, :resources

    def initialize
      @resources = []
    end

    def uri
      baseUri
    end

  end
end
