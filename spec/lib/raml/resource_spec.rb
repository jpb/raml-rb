require 'raml/resource'

describe Raml::Resource do

  describe '.new' do
    let(:parent) { double(uri: 'http://www.example.com') }
    subject { Raml::Resource.new(parent, '/cats') }
    its(:parent) { should == parent }
    its(:uri_partial) { should == '/cats' }
    its(:http_methods) { should == [] }
  end

  describe '#uri' do
    let(:parent) { double(uri: 'http://www.example.com') }
    let(:uri_partial) { '/cats' }
    subject { Raml::Resource.new(parent, uri_partial).uri }
    it { is_expected.to eq('http://www.example.com/cats') }

    context 'partial no slash' do
      let(:uri_partial) { 'cats' }
      it { is_expected.to eq('http://www.example.com/cats') }
    end

    context 'base trailing slash' do
      let(:parent) { double(uri: 'http://www.example.com') }
      it { is_expected.to eq('http://www.example.com/cats') }

      context 'partial no slash' do
        let(:uri_partial) { 'cats' }
        it { is_expected.to eq('http://www.example.com/cats') }
      end
    end
  end

end

