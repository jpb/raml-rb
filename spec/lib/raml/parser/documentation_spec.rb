require 'raml/parser/documentation'

describe Raml::Parser::Documentation do

  describe '#parse' do
    let(:data) { { 'title' => 'The title', 'content' => 'The content' } }
    let(:trait_names) { nil }
    let(:parent) { double() }
    subject { Raml::Parser::Documentation.new(parent).parse(data) }

    it { should be_kind_of Raml::Documentation }
    its(:title) { should == 'The title' }
    its(:content) { should == 'The content' }
  end

end
