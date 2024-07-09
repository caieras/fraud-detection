# frozen_string_literal: true

module Services
  module RiskEngine
    module Rules
      class TransactionFrequency
        MIN_TIME_BETWEEN_TRANSACTIONS = 60 # seconds

        def self.check(user_transactions, transaction_date)
          new(user_transactions, transaction_date).check
        end

        def initialize(user_transactions, transaction_date)
          @user_transactions = user_transactions
          @current_transaction_time = transaction_date
        end

        def check
          if too_many_transactions_in_row?
            { passed: false, message: 'Too many transactions in a row' }
          else
            { passed: true }
          end
        end

        private

        def too_many_transactions_in_row?
          return false if @user_transactions.empty?

          last_transaction_time = Time.parse(@user_transactions.last[:transaction_date])
          @current_transaction_time - last_transaction_time < MIN_TIME_BETWEEN_TRANSACTIONS
        end
      end
    end
  end
end
