require 'raml/parser/response'

describe Raml::Parser::Response do
  let(:parent) { double() }
  let(:instance) { Raml::Parser::Response.new(parent) }
  let(:code) { 201 }
  let(:attribute) { { 'body' => { 'cats' => {} } } }

  describe '#parse' do
    subject { instance.parse(code, attribute) }

    before do
      Raml::Parser::Body.any_instance.stub(:parse)
    end

    it { should be_kind_of Raml::Response }
    its(:code) { should == 201 }
    it 'should call through to body' do
      expect_any_instance_of(Raml::Parser::Body).to receive(:parse).with('cats', {}).once
      subject
    end
  end

  describe '#response' do
    before { instance.parse(code, attribute) }
    subject { instance.response }
    it { should be_kind_of Raml::Response }
  end

end

