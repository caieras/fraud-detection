module Services
  module RiskEngine
    class Analyzer
      include Services::Concerns

      def self.call(transaction, redis)
        new(transaction, redis).call
      end

      def initialize(transaction, redis)
        @current_transaction = transaction
        @redis = redis
        @response = ResponseBuilder.new
      end

      def call
        user_transactions = fetch_user_transactions

        rules = [
          Rules::TransactionFrequency.new(user_transactions, @current_transaction.transaction_date),
          Rules::AmountLimit.new(user_transactions, @current_transaction),
          Rules::ChargebackHistory.new(@current_transaction.user_id, @redis)
        ]

        rules.each do |rule|
          result = rule.check
          return @response.fail(body: result[:message]) unless result[:passed]
        end

        @response.success(body: 'Transaction approved')
      end

      private

      def fetch_user_transactions
        all_transactions = Models::Transaction.get_user_transactions(@current_transaction.id)
      end
    end
  end
end
