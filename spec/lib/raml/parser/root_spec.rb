require 'raml/parser/root'
require 'yaml'

describe Raml::Parser::Root do

  describe '#parse' do
    let(:raml) { YAML.load File.read('spec/fixtures/basic.raml') }
    subject { Raml::Parser::Root.new.parse(raml) }

    it { is_expected.to be_kind_of Raml::Root }
    its(:base_uri) { should == 'http://{environment}.api.com/{version}' }
    its(:uri) { should == 'http://{environment}.api.com/v1' }
    its(:version) { should == 'v1' }
    its(:base_uri_parameters) do
      should == {"environment" => { "description"=>"The deployed environment", "type"=>"String" }}
    end
    its(:media_type) { should == "application/json" }
    its(:secured_by) { should == [ "authenticationHeader" ] }
    its('resources.count') { should == 1 }
    its('resources.first.http_methods.count') { should == 2 }
    its('resources.first.http_methods.first.responses.count') { should == 0 }
    its('resources.first.http_methods.first.query_parameters.count') { should == 2 }
    its('documentation.count') { should == 0 }
    its('resources.first.resources.first.http_methods.first.responses.first.bodies.first.example') do
      should include '{"artist":"Pink Floyd", "title":"Wish You Were Here"}'
    end

    context 'trait-inherited attributes' do
      subject { Raml::Parser::Root.new.parse(raml).resources.first.http_methods.first.query_parameters.first }
      its(:name) { should == 'pages' }
      its(:description) { should == 'The number of pages to return' }
      its(:type) { should == 'number' }
    end

    context 'non trait-inherited attributes' do
      subject { Raml::Parser::Root.new.parse(raml).resources.first.http_methods.first.query_parameters.last }
      its(:name) { should == 'genre' }
      its(:description) { should == 'filter the songs by genre' }
      its(:type) { should == nil }
    end

    context 'using RAML types' do
      let(:raml) { YAML.load File.read('spec/fixtures/basic_raml_with_types.raml') }
      subject { Raml::Parser::Root.new.parse(raml) }

      it { is_expected.to be_kind_of Raml::Root }
      its(:base_uri) { should == 'http://api.e-bookmobile.com/{version}' }
      its(:uri) { should == 'http://api.e-bookmobile.com/v1' }
      its(:version) { should == 'v1' }
      its(:media_type) { should be_nil }
      its('resources.count') { should == 1 }
      its('resources.first.http_methods.count') { should == 1 }
      its('resources.first.http_methods.first.responses.count') { should == 1 }
      its('resources.first.http_methods.first.query_parameters.count') { should == 0 }
      its('documentation.count') { should == 0 }
      its('resources.first.http_methods.first.responses.first.bodies.first.type') { should == 'Authors' }
    end

    context 'using schemas' do
      let(:raml) { YAML.load File.read('spec/fixtures/basic_raml_with_schemas.raml') }
      subject { Raml::Parser::Root.new.parse(raml) }

      it { is_expected.to be_kind_of Raml::Root }
      its(:base_uri) { should == 'http://api.e-bookmobile.com/{version}' }
      its(:uri) { should == 'http://api.e-bookmobile.com/1.2' }
      its(:version) { should == 1.2 }
      its(:media_type) { should be_nil }
      its('resources.count') { should == 1 }
      its('resources.first.http_methods.count') { should == 1 }
      its('resources.first.http_methods.first.responses.count') { should == 1 }
      its('resources.first.http_methods.first.query_parameters.count') { should == 0 }
      its('documentation.count') { should == 0 }
      its('resources.first.http_methods.first.responses.first.bodies.first.schema') { should == 'Authors' }
    end
  end
end
