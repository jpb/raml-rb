module Raml
  class QueryParameter
    attr_accessor :name, :description, :type, :example

    def initialize(name)
      @name = name
    end

  end
end
