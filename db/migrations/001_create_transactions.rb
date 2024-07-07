Sequel.migration do
  change do
    create_table(:transactions) do
      primary_key :id
      Integer :transaction_id, null: false
      Integer :merchant_id, null: false
      Integer :user_id, null: false
      Integer :device_id, null: false
      String :card_number, null: false
      DateTime :transaction_date, null: false
      BigDecimal :transaction_amount, null: false, size: [10, 2]
      
      index :transaction_id, unique: true
      index :merchant_id
      index :user_id
    end
  end
end
