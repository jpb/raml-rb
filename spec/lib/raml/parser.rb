require 'raml/parser'
require 'yaml'

describe Raml::Parser do

  describe '#parse' do
    let(:raml) { File.read('spec/fixtures/basic.raml') }
    before do
      subject.stub(:parse)
      Raml::Parser.new.parse(raml)
    end
    subject { Raml::Parser::Root.any_instance }

    it { should have_received(:stub).with(YAML.load(raml)) }
  end

  describe '.parse' do
    let(:raml) { File.read('spec/fixtures/basic.raml') }
    before do
      subject.stub(:parse)
      Raml::Parser.parse(raml)
    end
    subject { Raml::Parser.any_instance }

    it { should have_received(:parse).with(raml) }
  end

  describe '.parse_file' do
    let(:raml) { File.read('spec/fixtures/basic.raml') }
    before do
      subject.stub(:parse)
      Raml::Parser.parse_file('spec/fixtures/basic.raml')
    end
    subject { Raml::Parser.any_instance }

    it { should have_received(:parse).with(raml) }
  end

  describe '.parse_file' do
    before do
      subject.stub(:parse_file)
      Raml::Parser.parse_file('path/to/file.raml')
    end
    subject { Raml::Parser.any_instance }

    it { should have_received(:parse_file).with('path/to/file.raml') }
  end

end
