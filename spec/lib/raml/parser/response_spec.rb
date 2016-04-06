require 'raml/parser/response'

describe Raml::Parser::Response do
  let(:instance) { Raml::Parser::Response.new }
  let(:code) { 201 }
  let(:attribute) { { 'body' => { 'cats' => {} } } }

  describe '#parse' do
    subject { instance.parse(code, attribute) }

    before do
      allow_any_instance_of(Raml::Parser::Body).to receive(:parse)
    end

    it { is_expected.to be_kind_of Raml::Response }
    its(:code) { should == 201 }
    it 'should call through to body' do
      expect_any_instance_of(Raml::Parser::Body).to receive(:parse).with('cats', {}).once
      subject
    end
  end

  describe '#response' do
    before { instance.parse(code, attribute) }
    subject { instance.response }
    it { is_expected.to be_kind_of Raml::Response }
  end

end

