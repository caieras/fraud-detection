module Models
  class Transaction < Sequel::Model
    include Redis::Objects

    plugin :validation_helpers
    plugin :timestamps

    list :user_transactions, global: true

    def before_create
      super
      sync_to_redis
    end

    def sync_to_redis
      transaction_data = {
        transaction_id:,
        user_id:,
        card_number:,
        transaction_date: transaction_date.iso8601,
        transaction_amount:,
        device_id:
      }.to_json

      self.class.user_transactions << transaction_data
    end

    def self.get_user_transactions(user_id)
      all_transactions = user_transactions.values
      user_transactions = all_transactions.map { |t| JSON.parse(t, symbolize_names: true) }
                                          .select { |t| t[:user_id] == user_id }

      user_transactions.map do |t|
        new(user_id: t[:user_id], transaction_id: t[:transaction_id], card_number: t[:card_number],
            transaction_date: Date.parse(t[:transaction_date]), transaction_amount: t[:transaction_amount],
            device_id: t[:device_id])
      end
    end

    def self.get_user_transactions_by_date_range(user_id, start_date, end_date)
      transactions = get_user_transactions(user_id)
      transactions.select { |t| t.date >= start_date && t.date <= end_date }
    end

    private

    def validate
      super
      validates_presence %i[transaction_id merchant_id user_id card_number transaction_date transaction_amount]
      validates_unique :transaction_id
      validates_numeric %i[transaction_id merchant_id user_id transaction_amount]
      validates_format(/\A\d{6}\*{6}\d{4}\z/, :card_number, message: 'must be in the format XXXXXX******XXXX')
    end
  end
end
