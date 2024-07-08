module Services
  module Transactions
    class FraudCheck
      include Services::Helpers

      def self.call(transaction_params)
        new(transaction_params).call
      end

      def initialize(transaction_params)
        @transaction_params = transaction_params
        @response = ResponseBuilder.new
        @redis = Application.redis
      end

      def call
        transaction = Models::Transaction.new(@transaction_params)
        
        return @response.fail(body: 'Invalid JSON Body').as_json unless transaction.valid?
        
        register_transaction(transaction)
        analyze_risk_score = Services::RiskEngine.call(transaction)

        if analyze_risk_score.success?
          @response.success(body: 'Transaction approved').as_json
        else
          @response.fail(body: 'Transaction rejected due to high risk').as_json
        end
      end

      private

      def register_transaction(transaction)
        @redis.rpush("user_transactions", transaction.to_json)
        @redis.rpush("merchant_transactions", transaction.to_json)

        @redis.ltrim("user_transactions:#{transaction.user_id}", 0, 9)
        @redis.lpush("user_transactions:#{transaction.user_id}", Time.now.to_i)
        @redis.ltrim("user_transactions:#{transaction.user_id}", 0, 9)
      end
    end
  end
end
