# raml-rb

A RAML parser, implemented in Ruby.

## Usage

```Ruby
raml = Raml::Parser.parse("#%RAML 0.8\ntitle: World Music API\nbaseUri: http://example.api.com/{version}")
raml = Rank::Parser.parse_file('path/to/file.raml')
```

## Todo

0. Parameters for Resource Types and Traits.
0. Ensure all attributes are supported.
0. Documentation generator.
0. RAML file generator.

## Author

James Brennan (james@jamesbrennan.ca)
