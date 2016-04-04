require 'core_ext/hash'

describe Hash do

  describe '#deep_merge' do
    subject { { key: 'left' }.deep_merge({ key: 'right'}) }
    it { is_expected.to eq({ key: 'right' }) }

    context 'nested hash' do
      subject { { key: { key: { key: 'left' } } }.deep_merge({ key: { key: { key: 'right' } } }) }
      it { is_expected.to eq({ key: { key: { key: 'right' } } }) }
    end

    context 'nested hash with nil on original hash' do
      subject { { key: { key: { key: nil } } }.deep_merge({ key: { key: { key: 'right' } } }) }
      it { is_expected.to eq({ key: { key: { key: 'right' } } }) }
    end

    context 'nested hash with nil on merged hash' do
      subject { { key: { key: { key: 'left' } } }.deep_merge({ key: { key: { key: nil } } }) }
      it { is_expected.to eq({ key: { key: { key: nil } } }) }
    end
  end

end
