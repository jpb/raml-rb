require 'yaml'

module Raml
  class Parser
    attr_accessor :yaml, :root

    def initialize(yaml)
      @yaml = YAML.load(yaml)
    end

    def parse
      @root = Root.new

      yaml.each do |key, value|
        parse_root(key, parse_value(value))
      end

      @root
    end

    private

      def underscore(string)
        string.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
        string.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
        string.tr!('-', '_')
        string.downcase
      end

      def parse_root(key, value)
        case key
        when *Root::ATTRIBUTES
          root.send("#{key}=".to_sym, parse_value(value))
        when /^\//
          root.resources << parse_resource(key, parse_value(value))
        else
          raise UnknownAttributeError.new "Unknown root key: #{key}"
        end
      end

      def parse_resource(parent, uri_partial, data)
        resource = Resource.new(parent, uri_partial)

        data.each do |key, value|
          case key
          when *Resource::ATTRIBUTES
            resource.send("#{key}=".to_sym, parse_value(value))
          when /^\//
            resource.resources << parse_resource(resource, key, parse_value(value))
          when *%w(get put post delete)
            resource.methods << parse_method(key, parse_value(value))
          else
            raise UnknownAttributeError.new "Unknown resource key: #{key}"
          end
        end

        resource
      end

      def parse_method(action, data)
        method = Method.new(action)

        data.each do |key, value|
          case key
          when *Method::ATTRIBUTES
            method.send("#{key}=".to_sym, parse_value(value))
          else
            raise UnknownAttributeError.new "Unknown method key: #{key}"
          end
        end

        method
      end

      def parse_response(code, data)
        response = Response.new(code)

        data.each do |key, value|
          case key
          when *Response::ATTRIBUTES
            response.send("#{key}=".to_sym, parse_value(value))
          when 'body'
            parse_value(value).each do |type, data|
              response.bodies << parse_body(type, data)
            end
          else
            raise UnknownAttributeError.new "Unknown response key: #{key}"
          end
        end

        response
      end

      def parse_body(type, data)
        body = Body.new(type)

        data.each do |key, value|
          case key
          when *Response::ATTRIBUTES
            response.send("#{key}=".to_sym, parse_value(value))
          else
            raise UnknownAttributeError.new "Unknown response key: #{key}"
          end
        end

        body
      end

      def parse_value(value)
        if value.strip.start_with?('include!')
          File.read value.match(/include!(.*)/)[1].strip
        else
          value
        end
      end

  end
end
