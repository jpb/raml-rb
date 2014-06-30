module Raml
  class Root
    ATTRIBUTES = %w[
      title
      baseUri
      version
    ]
    attr_accessor :title, :baseUri, :version, :resources, :documentation

    def initialize
      @resources = []
      @documentation = []
    end

    def uri
      baseUri.sub('{version}', version.to_s)
    end

  end
end
