module Models
  module Concerns
    module RedisRetriever
      def get_user_transactions(transaction_id)
        transaction = Transaction.find(id: transaction_id)

        transaction.recent_user_transactions.values[0..-2]
      end

      # def get_user_transactions_by_date_range(user_id, start_date, end_date)
      #   get_user_transactions(user_id).select do |t|
      #     (start_date..end_date).cover?(t.transaction_date)
      #   end
      # end

      # private

      # def new_from_redis(data)
      #   new(
      #     transaction_id: data[:transaction_id],
      #     user_id: data[:user_id],
      #     merchant_id: data[:merchant_id],
      #     last_four: data[:last_four],
      #     transaction_date: Date.parse(data[:transaction_date]),
      #     transaction_amount: data[:transaction_amount],
      #     device_id: data[:device_id]
      #   )
      # end
    end
  end
end
