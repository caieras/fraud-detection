require 'spec_helper'
require 'services/risk_engine/rules/transaction_frequency'

RSpec.describe Services::RiskEngine::Rules::TransactionFrequency do
  let(:transaction) { double('Transaction') }
  let(:user_transactions) { [] }

  describe '.check' do
    subject { described_class.check(user_transactions, transaction.transaction_date) }

    context 'when there are too many transactions in a row' do
      before do
        allow(transaction).to receive(:transaction_date).and_return(Time.new(2023, 1, 1, 12, 0, 30))
        user_transactions << { transaction_date: Time.new(2023, 1, 1, 12, 0, 0).to_s }
      end

      it 'returns failed check' do
        expect(subject).to eq({ passed: false, message: 'Too many transactions in a row' })
      end
    end

    context 'when there are not too many transactions in a row' do
      before do
        allow(transaction).to receive(:transaction_date).and_return(Time.new(2023, 1, 1, 12, 1, 1))
        user_transactions << { transaction_date: Time.new(2023, 1, 1, 12, 0, 0).to_s }
      end

      it 'returns passed check' do
        expect(subject).to eq({ passed: true })
      end
    end

    context 'when there are no previous transactions' do
      before do
        allow(transaction).to receive(:transaction_date).and_return(Time.new(2023, 1, 1, 12, 0, 0))
      end

      it 'returns passed check' do
        expect(subject).to eq({ passed: true })
      end
    end
  end

  describe '#too_many_transactions_in_row?' do
    subject { described_class.new(user_transactions, transaction.transaction_date).send(:too_many_transactions_in_row?) }

    context 'when there are no previous transactions' do
      before do
        allow(transaction).to receive(:transaction_date).and_return(Time.new(2023, 1, 1, 12, 0, 0))
      end

      it 'returns false' do
        expect(subject).to be false
      end
    end

    context 'when the last transaction is too recent' do
      before do
        allow(transaction).to receive(:transaction_date).and_return(Time.new(2023, 1, 1, 12, 0, 30))
        user_transactions << { transaction_date: Time.new(2023, 1, 1, 12, 0, 0).to_s }
      end

      it 'returns true' do
        expect(subject).to be true
      end
    end

    context 'when the last transaction is not too recent' do
      before do
        allow(transaction).to receive(:transaction_date).and_return(Time.new(2023, 1, 1, 12, 1, 1))
        user_transactions << { transaction_date: Time.new(2023, 1, 1, 12, 0, 0).to_s }
      end

      it 'returns false' do
        expect(subject).to be false
      end
    end
  end
end
