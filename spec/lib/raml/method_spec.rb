require 'raml/method'

describe Raml::Method do

  describe '.new' do
    subject { Raml::Method.new('delete') }
    its(:method) { should == 'delete' }
  end

  describe '#title' do
    let(:documentation) { Raml::Documentation.new }
    before { documentation.title = 'the title' }
    subject { documentation.title }
    it { is_expected.to eq('the title') }
  end

  describe '#response_code' do
  end

end
