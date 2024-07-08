module Models
  class Transaction < Sequel::Model    
    plugin :validation_helpers
    plugin :timestamps

    def validate
      super
      validates_presence [:transaction_id, :merchant_id, :user_id, :card_number, :transaction_date, :transaction_amount]
      validates_unique :transaction_id
      validates_numeric [:transaction_id, :merchant_id, :user_id, :transaction_amount]
      validates_format /\A\d{6}\*{6}\d{4}\z/, :card_number, message: 'must be in the format XXXXXX******XXXX'
    end
  end
end
