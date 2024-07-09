# frozen_string_literal: true

module Services
  module Transactions
    class FraudCheck
      def self.call(transaction_params)
        new(transaction_params).call
      end

      def initialize(transaction_params)
        @transaction_params = transaction_params
        @response = Services::Concerns::ResponseBuilder.new
        @redis = Application.redis
      end

      def call
        transaction = Models::Transaction.new(@transaction_params)
        return @response.fail(body: 'Invalid JSON Body').as_json unless transaction.valid?

        transaction.save
        analyze_risk_score = Services::RiskEngine::Analyzer.call(transaction, @redis)

        if analyze_risk_score.status == :success
          { transaction_id: transaction.id, recommendation: 'approve' }.to_json
        else
          chargeback_key = "user:#{transaction.user_id}:chargeback"
          @redis.set(chargeback_key, 1)
          transaction.update(chargeback: true)
          { transaction_id: transaction.id, recommendation: 'decline' }.to_json
        end
      end
    end
  end
end
