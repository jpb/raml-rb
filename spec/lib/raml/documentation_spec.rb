require 'raml/documentation'

describe Raml::Documentation do

  describe '#title' do
    let(:documentation) { Raml::Documentation.new }
    before { documentation.title = 'the title' }
    subject { documentation.title }
    it { is_expected.to eq('the title') }
  end

  describe '#content' do
    let(:documentation) { Raml::Documentation.new }
    before { documentation.content = 'the content' }
    subject { documentation.content }
    it { is_expected.to eq('the content') }
  end

end
