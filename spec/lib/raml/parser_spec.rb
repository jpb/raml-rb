require 'raml/parser'

describe Raml::Parser do
  describe '#parse' do
    let(:raml) { File.read('spec/fixtures/basic.raml') }
    subject { Raml::Parser.new(raml).parse }
    it { should be_kind_of Raml::Root }
    its('resources.count') { should == 2 }
    its('documentation.count') { should == 0 }
    its(:uri) { should == 'http://example.api.com/v1' }
    its(:version) { should == 'v1' }
    context 'traits' do
      subject { Raml::Parser.new(raml).parse.resources.fetch(1).methods.first.query_parameters.first }
      its(:name) { should == 'pages' }
      its(:description) { should == 'The number of pages to return' }
      its(:type) { should == 'number' }
    end
  end
end
