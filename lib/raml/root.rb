module Raml
  class Root
    attr_accessor :title, :base_uri, :version, :resources, :documentation, :types,
                  :base_uri_parameters, :media_type, :security_schemes, :secured_by,
                  :schemas

    def initialize
      @resources = []
      @documentation = []
    end

    def uri
      base_uri.sub('{version}', version.to_s)
    end

    def path
      ''
    end

  end
end
