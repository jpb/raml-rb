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

    def parse(yaml)
      raml = YAML.load(yaml)
      Raml::Parser::Root.new.parse(raml)
    end

    def parse_file(path)
      parse File.read(path)
    end

    def self.parse(yaml)
      self.new.parse(yaml)
    end

    def self.parse_file(path)
      self.new.parse_file(path)
    end

  end
end
