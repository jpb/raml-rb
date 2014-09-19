module Raml
  class QueryParameter
    attr_accessor :name, :description, :type, :example, :required

    def initialize(name)
      @name = name
      @required = false
    end

  end
end
