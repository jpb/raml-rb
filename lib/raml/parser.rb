require 'yaml'
require 'raml/errors/unknown_attribute_error'
require 'raml/root'
require 'raml/resource'
require 'raml/method'
require 'raml/response'
require 'raml/body'
require 'raml/query_parameter'

module Raml
  class Parser
    attr_accessor :yaml, :root, :traits

    def initialize(yaml)
      @yaml = YAML.load(yaml)
      @traits = {}
    end

    def parse
      parse_root(yaml)
    end

    private

      def underscore(string)
        string.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
          .gsub(/([a-z\d])([A-Z])/,'\1_\2')
          .tr('-', '_')
          .downcase
      end

      def parse_root(data)
        @root = Root.new
        parse_root_attributes(@root, data)
      end

      def parse_root_attributes(root, data)
        data.each do |key, value|
          key = underscore(key)
          case key
          when *Root::ATTRIBUTES
            root.send("#{key}=".to_sym, parse_value(value))
          when 'traits'
            parse_traits(parse_value(value))
          when 'documentation'
            parse_documentation(parse_value(value))
          when /^\//
            root.resources << parse_resource(root, key, parse_value(value))
          else
            raise UnknownAttributeError.new "Unknown root key: #{key}"
          end
        end

        root
      end

      def parse_traits(traits)
        traits.each do |name, data|
          @traits[name] = data
        end
      end

      def parse_documentation(data)
        data = data.is_a?(Array) ? data : [data]

        data.each do |values|
          root.documentation << Documentation.new
          values.each do |key, value|
            key = underscore(key)
            case key
            when *Documentation::ATTRIBUTES
              documentation.send("#{key}=".to_sym, parse_value(value))
            end
          end
        end
      end

      def parse_resource(parent, uri_partial, data)
        resource = Resource.new(parent, uri_partial)
        parse_resource_attributes(resource, data)
      end

      def parse_resource_attributes(resource, data)
        data.each do |key, value|
          key = underscore(key)
          case key
          when *Resource::ATTRIBUTES
            resource.send("#{key}=".to_sym, parse_value(value))
          when 'is'
            value = value.is_a?(Array) ? value : [value]
            value.each do |name|
              unless traits[name].nil?
                resource = parse_resource_attributes(resource, traits[name])
              end
            end
          when /^\//
            root.resources << parse_resource(resource, key, parse_value(value))
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
        parse_method_attributes(method, data)
      end

      def parse_method_attributes(method, data)
        data.each do |key, value|
          key = underscore(key)
          case key
          when *Method::ATTRIBUTES
            method.send("#{key}=".to_sym, parse_value(value))
          when 'is'
            value = value.is_a?(Array) ? value : [value]
            value.each do |name|
              unless traits[name].nil?
                method = parse_method_attributes(method, traits[name])
              end
            end
          when 'responses'
            parse_value(value).each do |code, response_data|
              method.responses << parse_response(code, response_data)
            end
          when 'query_parameters'
            parse_value(value).each do |name, parameter_data|
              method.query_parameters << parse_query_parameter(name, parameter_data)
            end
          else
            raise UnknownAttributeError.new "Unknown method key: #{key}"
          end
        end if data

        method
      end

      def parse_response(code, data)
        response = Response.new(code)
        parse_response_attributes(response, data)
      end

      def parse_response_attributes(response, data)
        data.each do |key, value|
          key = underscore(key)
          case key
          when *Response::ATTRIBUTES
            response.send("#{key}=".to_sym, parse_value(value))
          when 'is'
            value = value.is_a?(Array) ? value : [value]
            value.each do |name|
              unless traits[name].nil?
                response = parse_response_attributes(response, traits[name])
              end
            end
          when 'body'
            parse_value(value).each do |type, body_data|
              response.bodies << parse_body(type, body_data)
            end
          else
            raise UnknownAttributeError.new "Unknown response key: #{key}"
          end
        end

        response
      end

      def parse_query_parameter(name, data)
        query_parameter = QueryParameter.new(name)
        parse_query_parameter_attributes(query_parameter, data)
      end

      def parse_query_parameter_attributes(query_parameter, data)
        data.each do |key, value|
          key = underscore(key)
          case key
          when *QueryParameter::ATTRIBUTES
            query_parameter.send("#{key}=".to_sym, parse_value(value))
          when 'is'
            value = value.is_a?(Array) ? value : [value]
            value.each do |name|
              unless traits[name].nil?
                body = parse_query_paramter_attributes(query_parameter, traits[name])
              end
            end
          else
            raise UnknownAttributeError.new "Unknown query paramter key: #{key}"
          end
        end if data

        query_parameter
      end

      def parse_body(type, data)
        body = Body.new(type)
        parse_body_attributes(body, data)
      end

      def parse_body_attributes(body, data)
        data.each do |key, value|
          key = underscore(key)
          case key
          when *Body::ATTRIBUTES
            body.send("#{key}=".to_sym, parse_value(value))
          when 'is'
            value = value.is_a?(Array) ? value : [value]
            value.each do |name|
              unless traits[name].nil?
                body = parse_body_attributes(body, traits[name])
              end
            end
          else
            raise UnknownAttributeError.new "Unknown body key: #{key}"
          end
        end if data

        body
      end

      def parse_value(value)
        if value.is_a?(String) && value.strip.start_with?('include!')
          File.read value.match(/include!(.*)/)[1].strip
        else
          value
        end
      end

  end
end
