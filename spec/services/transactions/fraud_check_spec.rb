require 'services/transactions/fraud_check'
require 'spec_helper'

RSpec.describe Services::Transactions::FraudCheck do
  let(:transaction_params) { { user_id: 123, amount: 100 } }
  let(:redis) { double('Redis') }
  let(:response_builder) { double('ResponseBuilder') }
  let(:transaction) { double('Transaction') }
  let(:risk_analyzer) { double('RiskAnalyzer') }

  before do
    stub_const("Services::Concerns::ResponseBuilder", Class.new)
    stub_const("Application", double(redis: redis))
    stub_const("Models::Transaction", Class.new)
    stub_const("Services::RiskEngine::Analyzer", risk_analyzer)

    allow(Services::Concerns::ResponseBuilder).to receive(:new).and_return(response_builder)
    allow(Models::Transaction).to receive(:new).and_return(transaction)
  end

  describe '.call' do
    it 'creates a new instance and calls call' do
      instance = instance_double(described_class)
      expect(described_class).to receive(:new).with(transaction_params).and_return(instance)
      expect(instance).to receive(:call)
      described_class.call(transaction_params)
    end
  end

  describe '#call' do
    subject { described_class.new(transaction_params).call }

    context 'when transaction is invalid' do
      before do
        allow(transaction).to receive(:valid?).and_return(false)
        allow(response_builder).to receive(:fail).with(body: 'Invalid JSON Body').and_return(double(as_json: 'invalid json response'))
      end

      it 'returns failure response' do
        expect(subject).to eq('invalid json response')
      end
    end

    context 'when transaction is valid' do
      before do
        allow(transaction).to receive(:valid?).and_return(true)
        allow(transaction).to receive(:save)
        allow(transaction).to receive(:user_id).and_return(123)
      end

      context 'when risk analysis passes' do
        before do
          allow(risk_analyzer).to receive(:call).and_return(double(status: :success))
          allow(response_builder).to receive(:success).with(body: 'Transaction approved').and_return(double(as_json: 'success response'))
        end

        it 'returns success response' do
          expect(subject).to eq('success response')
        end
      end

      context 'when risk analysis fails' do
        before do
          allow(risk_analyzer).to receive(:call).and_return(double(status: :failure))
          allow(redis).to receive(:set)
          allow(transaction).to receive(:update)
          allow(response_builder).to receive(:fail).with(body: 'Transaction rejected due to high risk').and_return(double(as_json: 'failure response'))
        end

        it 'sets chargeback in Redis' do
          expect(redis).to receive(:set).with("user:123:chargeback", 1)
          subject
        end

        it 'updates transaction with chargeback' do
          expect(transaction).to receive(:update).with(chargeback: true)
          subject
        end

        it 'returns failure response' do
          expect(subject).to eq('failure response')
        end
      end
    end
  end
end
