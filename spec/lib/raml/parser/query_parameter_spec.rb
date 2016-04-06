require 'raml/parser/query_parameter'

describe Raml::Parser::QueryParameter do
  let(:instance) { Raml::Parser::QueryParameter.new }
  let(:type) { 'application/json' }
  let(:attribute) { { 'description' => 'dogs', 'type' => 'cats', 'example' => 'birds' } }

  describe '#parse' do
    subject { instance.parse(type, attribute) }

    it { is_expected.to be_kind_of Raml::QueryParameter }
    its(:description) { should == 'dogs' }
    its(:type) { should == 'cats' }
    its(:example) { should == 'birds' }
  end

  describe '#query_parameter' do
    before { instance.parse(type, attribute) }
    subject { instance.query_parameter }
    it { is_expected.to be_kind_of Raml::QueryParameter }
  end

end
