require 'raml/response'

describe Raml::Response do

  describe '.new' do
    subject { Raml::Response.new(201) }
    its(:code) { should == 201 }
    its(:bodies) { should == [] }
  end

  describe '#code' do
    let(:response) { Raml::Response.new(201) }
    before { response.code = 'the code' }
    subject { response.code }
    it { is_expected.to eq('the code') }
  end

  describe '#bodies' do
    let(:response) { Raml::Response.new(201) }
    before { response.bodies = 'the bodies' }
    subject { response.bodies }
    it { is_expected.to eq('the bodies') }
  end

end
