require 'spec_helper'
require 'services/risk_engine/rules/chargeback_history'

RSpec.describe Services::RiskEngine::Rules::ChargebackHistory do
  let(:user_id) { 123 }
  let(:redis) { double('Redis') }

  describe '.check' do
    subject { described_class.check(user_id, redis) }

    context 'when user has chargeback history' do
      before do
        allow(redis).to receive(:exists?).with("user:#{user_id}:chargeback").and_return(true)
      end

      it 'returns failed check' do
        expect(subject).to eq({ passed: false, message: 'Bad chargeback history' })
      end
    end

    context 'when user has no chargeback history' do
      before do
        allow(redis).to receive(:exists?).with("user:#{user_id}:chargeback").and_return(false)
      end

      it 'returns passed check' do
        expect(subject).to eq({ passed: true })
      end
    end
  end

  describe '#had_chargeback?' do
    subject { described_class.new(user_id, redis).send(:had_chargeback?) }

    context 'when user has chargeback history' do
      before do
        allow(redis).to receive(:exists?).with("user:#{user_id}:chargeback").and_return(true)
      end

      it 'returns true' do
        expect(subject).to be true
      end
    end

    context 'when user has no chargeback history' do
      before do
        allow(redis).to receive(:exists?).with("user:#{user_id}:chargeback").and_return(false)
      end

      it 'returns false' do
        expect(subject).to be false
      end
    end
  end
end
