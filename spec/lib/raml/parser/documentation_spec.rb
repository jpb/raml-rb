require 'raml/parser/documentation'

describe Raml::Parser::Documentation do

  describe '#parse' do
    let(:data) { { 'title' => 'The title', 'content' => 'The content' } }
    let(:trait_names) { nil }
    let(:parent) { double(traits: { 'with_content' => { 'title' => 'Trait title', 'content' => 'Trait content' } }, trait_names: trait_names) }
    subject { Raml::Parser::Documentation.new(parent).parse(data) }

    it { should be_kind_of Raml::Documentation }
    its(:title) { should == 'The title' }
    its(:content) { should == 'The content' }

    context 'traits' do
      let(:data) { { 'title' => 'The title', 'content' => 'The content', 'is' => [ 'with_content' ] } }
      its(:title) { should == 'Trait title' }
      its(:content) { should == 'Trait content' }
    end
  end

end
