# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'raml/version'

Gem::Specification.new do |spec|
  spec.name          = 'raml-rb'
  spec.version       = Raml::VERSION
  spec.authors       = ['James Brennan']
  spec.email         = ['james@jamesbrennan.ca']
  spec.summary       = %q{A RAML parser implemented in Ruby}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split("\n")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0.0'
end
