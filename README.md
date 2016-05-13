# raml-rb

[![Gem Version](https://badge.fury.io/rb/raml-rb.svg)](https://badge.fury.io/rb/raml-rb) [![Build Status](https://travis-ci.org/jpb/raml-rb.svg?branch=master)](https://travis-ci.org/jpb/raml-rb) [![Coverage Status](https://coveralls.io/repos/github/jpb/raml-rb/badge.svg?branch=master)](https://coveralls.io/github/jpb/raml-rb?branch=master) [![Code Climate](https://codeclimate.com/github/jpb/raml-rb/badges/gpa.svg)](https://codeclimate.com/github/jpb/raml-rb)

A RAML parser, implemented in Ruby.

## Installation

```
gem install raml-rb
```

## Usage

```Ruby
raml = Raml::Parser.parse("#%RAML 0.8\ntitle: World Music API\nbaseUri: http://example.api.com/{version}")
raml = Raml::Parser.parse_file('path/to/file.raml')
```

## Todo

0. Parameters for Resource Types and Traits.
0. Ensure all attributes are supported.
0. Documentation generator.
0. RAML file generator.

## Author

James Brennan (james@jamesbrennan.ca)
