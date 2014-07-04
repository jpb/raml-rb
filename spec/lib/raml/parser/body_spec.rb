require 'raml/parser/body'

describe Raml::Parser::Body do
  let(:instance) { Raml::Parser::Body.new }
  let(:type) { 'application/json' }
  let(:attribute) { { 'schema' => 'dogs' } }

  describe '#parse' do
    subject { instance.parse(type, attribute) }

    it { should be_kind_of Raml::Body }
    its(:schema) { should == 'dogs' }
  end

  describe '#body' do
    before { instance.parse(type, attribute) }
    subject { instance.body }
    it { should be_kind_of Raml::Body }
  end

end
