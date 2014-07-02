require 'raml/parser/body'

describe Raml::Parser::Body do
  let(:parent) { double(traits: { 'is_cat' => { 'schema' => 'cats' } }, trait_names: []) }
  let(:instance) { Raml::Parser::Body.new(parent) }
  let(:type) { 'application/json' }
  let(:data) { { 'schema' => 'dogs' } }

  describe '#parse' do
    subject { instance.parse(type, data) }

    it { should be_kind_of Raml::Body }
    its(:schema) { should == 'dogs' }

    context 'trait' do
      let(:data) { { 'schema' => 'dogs', 'is' => [ 'is_cat' ] } }
      its(:schema) { should == 'cats' }
    end
  end

  describe '#body' do
    before { instance.parse(type, data) }
    subject { instance.body }
    it { should be_kind_of Raml::Body }
  end

end
