require 'raml/parser/method'

describe Raml::Parser::Method do

  describe '#parse' do
    let(:attribute) { { 'description' => 'The description', 'headers' => [{ 'key' => 'value' }], 'responses' => ['cats'], 'query_parameters' => ['dogs'] } }
    let(:parent) { double(traits: { 'with_content' => { 'title' => 'Trait title', 'content' => 'Trait content' } }, trait_names: nil) }
    before do
      Raml::Parser::Response.any_instance.stub(:parse).and_return('cats')
      Raml::Parser::QueryParameter.any_instance.stub(:parse).and_return('dogs')
    end
    subject { Raml::Parser::Method.new(parent).parse('get', attribute) }

    it { should be_kind_of Raml::Method }
    its(:method) { should == 'get' }
    its(:description) { should == 'The description' }
    its(:headers) { should == [ 'key' => 'value' ] }
    its(:responses) { should == ['cats'] }
    its(:query_parameters) { should == ['dogs'] }

  end

end
