require 'raml/parser/root'
require 'yaml'

describe Raml::Parser::Root do

  describe '#parse' do
    let(:raml) { YAML.load File.read('spec/fixtures/basic.raml') }
    subject { Raml::Parser::Root.new.parse(raml) }

    it { should be_kind_of Raml::Root }
    its('resources.count') { should == 2 }
    its('documentation.count') { should == 0 }
    its(:uri) { should == 'http://example.api.com/v1' }
    its(:version) { should == 'v1' }

    context 'trait-inherited attributes' do
      subject { Raml::Parser::Root.new.parse(raml).resources.fetch(1).methods.first.query_parameters.first }
      its(:name) { should == 'pages' }
      its(:description) { should == 'The number of pages to return' }
      its(:type) { should == 'number' }
    end

    context 'non trait-inherited attributes' do
      subject { Raml::Parser::Root.new.parse(raml).resources.fetch(1).methods.first.query_parameters.last }
      its(:name) { should == 'genre' }
      its(:description) { should == 'filter the songs by genre' }
      its(:type) { should == nil }
    end
  end

end
