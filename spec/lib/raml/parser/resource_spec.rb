require 'raml/parser/resource'

describe Raml::Parser::Resource do

  let(:parent) { double(resource_types: { 'cats' => { 'post' => {} } }) }
  let(:resources) { double('<<'.to_sym => nil) }
  let(:parent_node) { double(resources: resources) }
  let(:instance) { Raml::Parser::Resource.new(parent) }
  let(:uri_partial) { '/cats' }
  let(:attributes) { { } }

  describe '#parse' do
    subject { instance.parse(parent_node, uri_partial, attributes) }
    it { should be_kind_of Raml::Resource }

    context 'resource' do
      before { subject }
      let(:attributes) { { '/bar' => {} } }
      it 'should create a method' do
        resources.should have_received('<<').with(kind_of(Raml::Resource))
      end
    end

    %w[get put post delete].each do |method|
      context method do
        let(:attributes) { { method => 'method attributess' } }
        it 'should call through to method parser' do
          expect_any_instance_of(Raml::Parser::Method).to receive(:parse).with(method, 'method attributess').once
          instance.parse(parent_node, uri_partial, attributes)
        end
      end
    end

    context 'resource type' do
      let(:attributes) { { 'type' => 'cats' } }
      it 'should call through to method parser' do
        expect_any_instance_of(Raml::Parser::Method).to receive(:parse).with('post', {}).once
        instance.parse(parent_node, uri_partial, attributes)
      end
    end
  end

  describe '#resource' do
    before { instance.parse(parent_node, uri_partial, attributes) }
    subject { instance.resource }
    it { should be_kind_of Raml::Resource }
  end

end
