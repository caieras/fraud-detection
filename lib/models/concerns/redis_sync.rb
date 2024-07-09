module Models
  module Concerns
    module RedisSync
      def sync_to_redis
        self.recent_user_transactions << transaction_data
      end

      private

      def transaction_data
        {
          transaction_id:,
          user_id:,
          merchant_id:,
          last_four:,
          transaction_date: transaction_date.iso8601,
          transaction_amount:,
          device_id:,
          chargeback:
        }
      end
    end
  end
end
