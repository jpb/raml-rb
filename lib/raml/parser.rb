require 'yaml'
require 'raml/parser/root'
require 'raml/parser/resource'
require 'raml/parser/method'
require 'raml/parser/response'
require 'raml/parser/body'
require 'raml/parser/query_parameter'

module Raml
  class Parser

    def initialize
      Psych.add_domain_type 'include', 'include' do |_, value|
        raw = File.read(value)
        YAML.load(raw)
      end
    end

    def parse(yaml)
      raml = YAML.load(yaml)
      Raml::Parser::Root.new.parse(raml)
    end

    def parse_file(path)
      # Change directories so that relative file !includes work properly
      wd = Dir.pwd
      Dir.chdir File.dirname(path)

      raml = parse File.read(File.basename(path))

      Dir.chdir wd
      raml
    end

    def self.parse(yaml)
      self.new.parse(yaml)
    end

    def self.parse_file(path)
      self.new.parse_file(path)
    end

  end
end
