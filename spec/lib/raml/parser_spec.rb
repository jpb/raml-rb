require 'raml/parser'

describe Raml::Parser do
  describe '#parse' do
    let(:raml) { File.read('spec/fixtures/basic.raml') }
    subject { Raml::Parser.new(raml).parse }
    it { should be_kind_of Raml::Root }
  end
end
