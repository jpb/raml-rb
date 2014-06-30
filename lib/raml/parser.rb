require 'yaml'
require 'raml/errors/unknown_attribute_error'
require 'raml/parser/root'
require 'raml/parser/resource'
require 'raml/parser/method'
require 'raml/parser/response'
require 'raml/parser/body'
require 'raml/parser/query_parameter'

module Raml
  class Parser
    attr_accessor :yaml

    def initialize(yaml)
      @yaml = YAML.load(yaml)
    end

    def parse
      Parser::Root.new.parse(yaml)
    end

  end
end
