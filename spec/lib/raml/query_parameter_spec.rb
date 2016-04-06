require 'raml/query_parameter'

describe Raml::QueryParameter do

  describe '.new' do
    let(:query_parameter) { Raml::QueryParameter.new('name') }
    subject { query_parameter.name }
    it { is_expected.to eq('name') }
  end

  describe '#name' do
    let(:query_parameter) { Raml::QueryParameter.new('name') }
    before { query_parameter.name = 'the name' }
    subject { query_parameter.name }
    it { is_expected.to eq('the name') }
  end

  describe '#description' do
    let(:query_parameter) { Raml::QueryParameter.new('name') }
    before { query_parameter.description = 'the description' }
    subject { query_parameter.description }
    it { is_expected.to eq('the description') }
  end

  describe '#type' do
    let(:query_parameter) { Raml::QueryParameter.new('name') }
    before { query_parameter.type = 'the type' }
    subject { query_parameter.type }
    it { is_expected.to eq('the type') }
  end

  describe '#example' do
    let(:query_parameter) { Raml::QueryParameter.new('name') }
    before { query_parameter.example = 'the example' }
    subject { query_parameter.example }
    it { is_expected.to eq('the example') }
  end

end

