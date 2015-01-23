require 'raml/parser/resource'

describe Raml::Parser::Resource do

  let(:parent) { double(resource_types: { 'cats' => { 'post' => {} } }) }
  let(:resources) { double('<<'.to_sym => nil) }
  let(:resource) { double('<<'.to_sym => nil, resources: resources) }
  let(:parent_node) { double(resources: resources) }
  let(:instance) { Raml::Parser::Resource.new(parent) }
  let(:uri_partial) { '/cats' }
  let(:attributes) { { } }

  describe '#parse' do
    subject { instance.parse(parent_node, uri_partial, attributes) }
    it { should be_kind_of Raml::Resource }

    context 'resource' do
      before do
        allow(instance).to receive(:resource).and_return(resource)
        subject
      end
      let(:attributes) { { '/bar' => {} } }
      it 'should create a method' do
        resource.resources.should have_received('<<').with(kind_of(Raml::Resource))
      end
    end


    { 'display_name' => 'Catgeory', 'description' => 'resource description' }.each do |key, value|
      context "attribute: #{key}" do
        let(:attributes) { { key => value } }
        it 'should pass through display_name attribute' do
          subject.send(key.to_sym).should == value
        end
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
