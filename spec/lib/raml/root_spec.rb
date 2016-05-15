require 'raml/root'

describe Raml::Root do

  describe '#resources' do
    subject { Raml::Root.new.resources }
    it { is_expected.to be_kind_of Array }
  end

  describe '#documentation' do
    subject { Raml::Root.new.documentation }
    it { is_expected.to be_kind_of Array }
  end

  describe '#uri' do
    let(:root) { Raml::Root.new }
    before { root.base_uri = 'http://example.com' }
    subject { root.uri }
    it { is_expected.to eq('http://example.com') }
  end

  describe '#title' do
    let(:root) { Raml::Root.new }
    before { root.title = 'My RAML' }
    subject { root.title }
    it { is_expected.to eq('My RAML') }
  end

  describe '#version' do
    let(:root) { Raml::Root.new }
    before { root.version = '1.0' }
    subject { root.version }
    it { is_expected.to eq('1.0') }
  end

  describe '#base_uri_parameters' do
    let(:root) { Raml::Root.new }
    before { root.base_uri_parameters = '' }
    subject { root.base_uri_parameters }
    it { is_expected.to eq('') }
  end

  describe '#media_type' do
    let(:root) { Raml::Root.new }
    before { root.media_type = 'application/json' }
    subject { root.media_type }
    it { is_expected.to eq('application/json') }
  end
end
