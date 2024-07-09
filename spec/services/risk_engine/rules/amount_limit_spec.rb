require 'spec_helper'
require 'services/risk_engine/rules/amount_limit'

RSpec.describe Services::RiskEngine::Rules::AmountLimit do
  let(:transaction) { double('Transaction') }
  let(:user_transactions) { [] }

  describe '.check' do
    subject { described_class.check(user_transactions, transaction) }

    context 'when transaction amount exceeds limit' do
      before do
        allow(transaction).to receive(:transaction_date).and_return(Time.new(2023, 1, 1, 12, 0, 0))
        allow(transaction).to receive(:transaction_amount).and_return(25_000)
      end

      it 'returns failed check' do
        expect(subject).to eq({ passed: false, message: 'Amount limit exceeded' })
      end
    end

    context 'when transaction amount is within limit' do
      before do
        allow(transaction).to receive(:transaction_date).and_return(Time.new(2023, 1, 1, 12, 0, 0))
        allow(transaction).to receive(:transaction_amount).and_return(15_000)
      end

      it 'returns passed check' do
        expect(subject).to eq({ passed: true })
      end
    end

    context 'when transaction is during night time' do
      before do
        allow(transaction).to receive(:transaction_date).and_return(Time.new(2023, 1, 1, 22, 0, 0))
        allow(transaction).to receive(:transaction_amount).and_return(11_000)
      end

      it 'returns failed check' do
        expect(subject).to eq({ passed: false, message: 'Amount limit exceeded' })
      end
    end
  end
end
