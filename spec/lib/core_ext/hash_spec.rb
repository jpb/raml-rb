require 'core_ext/hash'

describe Hash do

  describe '#deep_merge' do
    subject { { key: 'left' }.deep_merge({ key: 'right'}) }
    it { should == { key: 'right' } }

    context 'nested hash' do
      subject { { key: { key: { key: 'left' } } }.deep_merge({ key: { key: { key: 'right' } } }) }
      it { should == { key: { key: { key: 'right' } } } }
    end

    context 'nested hash with nil on original hash' do
      subject { { key: { key: { key: nil } } }.deep_merge({ key: { key: { key: 'right' } } }) }
      it { should == { key: { key: { key: 'right' } } } }
    end

    context 'nested hash with nil on merged hash' do
      subject { { key: { key: { key: 'left' } } }.deep_merge({ key: { key: { key: nil } } }) }
      it { should == { key: { key: { key: nil } } } }
    end
  end

end
