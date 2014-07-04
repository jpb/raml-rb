require 'raml/body'

describe Raml::Body do

  describe '.new' do
    subject { Raml::Body.new('the type') }
    its(:type) { should == 'the type' }
  end

  describe '#type' do
    let(:body) { Raml::Body.new('the type') }
    before { body.type = 'type' }
    subject { body.type }
    it { should == 'type' }
  end

  describe '#schema' do
    let(:body) { Raml::Body.new('the type') }
    before { body.schema = 'schema' }
    subject { body.schema }
    it { should == 'schema' }
  end

end
