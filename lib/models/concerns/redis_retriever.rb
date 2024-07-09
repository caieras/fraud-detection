module Models
  module Concerns
    module RedisRetriever
      def get_user_transactions(transaction_id)
        transaction = Transaction.find(id: transaction_id)

        transaction.recent_user_transactions.values[0..-2]
      end
    end
  end
end
