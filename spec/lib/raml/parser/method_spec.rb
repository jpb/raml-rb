require 'raml/parser/method'

describe Raml::Parser::Method do

  describe '#parse' do
    let(:attributes) { { 'description' => 'The description', 'headers' => [{ 'key' => 'value' }], 'responses' => ['cats'], 'query_parameters' => ['dogs'], 'body' => { 'application/json' => { 'example' => '{"cats": "dogs"}'} } } }
    let(:parent) { double(traits: { 'cats' => { 'description' => 'Trait description', 'headers' => { 'trait_key' => 'trait_value' } } }, trait_names: nil) }
    before do
      allow_any_instance_of(Raml::Parser::Response).to receive(:parse).and_return('cats')
      allow_any_instance_of(Raml::Parser::QueryParameter).to receive(:parse).and_return('dogs')
    end
    subject { Raml::Parser::Method.new(parent).parse('get', attributes) }

    it { is_expected.to be_kind_of Raml::Method }
    its(:method) { should == 'get' }
    its(:description) { should == 'The description' }
    its(:headers) { should == [ { 'key' => 'value' } ] }
    its(:responses) { should == ['cats'] }
    its(:query_parameters) { should == ['dogs'] }
    its(:'bodies.first.example') { should == '{"cats": "dogs"}' }

    context 'with trait' do
      let(:attributes) { { 'is' => [ 'cats' ], 'responses' => ['cats'], 'query_parameters' => ['dogs'] } }
      its(:description) { should == 'Trait description' }
      its(:headers) { [ { 'trait_key' => 'trait_value' } ] }
    end

    context 'override trait attributes' do
      let(:attributes) { { 'is' => [ 'cats' ], 'description' => 'The description', 'headers' => [{ 'key' => 'value' }], 'responses' => ['cats'], 'query_parameters' => ['dogs'] } }
      its(:description) { should == 'The description' }
      its(:headers) { should == [ { 'key' => 'value' } ] }
    end

  end

end
