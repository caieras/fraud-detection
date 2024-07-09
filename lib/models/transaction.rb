module Models
  class Transaction < Sequel::Model
    include Redis::Objects
    include Concerns::RedisSync
    
    extend Concerns::RedisRetriever

    redis_id_field :user_id

    plugin :validation_helpers
    plugin :timestamps
    
    plugin :column_encryption do |enc|
      enc.key 0, ENV.fetch('ENCRYPTION_KEY')
      enc.column :card_number, searchable: true
    end

    # set :recent_transactions, :marshal => true, :global => true
    list :recent_user_transactions, :marshal => true, :maxlength => 5

    def before_save
      super
      self.last_four = card_number[-4..]
    end

    def after_save
      super
      sync_to_redis
    end
  
    def validate
      super
      validates_presence %i[transaction_id merchant_id user_id card_number transaction_date transaction_amount]
      validates_unique :transaction_id
      validates_numeric %i[transaction_id merchant_id user_id transaction_amount]
      validates_format(/\A\d{6}\*{6}\d{4}\z/, :card_number, message: 'must be in the format XXXXXX******XXXX')
    end
  end
end
