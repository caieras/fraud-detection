Sequel.migration do
  change do
    create_table(:transactions) do
      primary_key :id
      Integer :transaction_id, null: false
      Integer :merchant_id, null: false
      Integer :user_id, null: false
      Integer :device_id
      String :card_number, null: false
      String :last_four, null: false
      DateTime :transaction_date, null: false
      Decimal :transaction_amount, null: false
      TrueClass :chargeback, default: false
      
      index :transaction_id, unique: true
      index :merchant_id
      index :user_id
    end
  end
end
