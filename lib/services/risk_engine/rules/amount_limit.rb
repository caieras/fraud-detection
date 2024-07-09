# frozen_string_literal: true

module Services
  module RiskEngine
    module Rules
      class AmountLimit
        NIGHT_START_HOUR = 20
        NIGHT_END_HOUR = 2
        MAX_TRANSACTION_AMOUNT = 10_000

        def self.check(user_transactions, transaction)
          new(user_transactions, transaction).check
        end

        def initialize(user_transactions, transaction)
          @user_transactions = user_transactions
          @current_transaction = transaction
        end

        def check
          if exceeds_amount_limit?
            { passed: false, message: 'Amount limit exceeded' }
          else
            { passed: true }
          end
        end

        private

        def exceeds_amount_limit?
          current_hour = @current_transaction.transaction_date.hour
          night_time = (current_hour >= NIGHT_START_HOUR || current_hour < NIGHT_END_HOUR)
          
          limit = night_time ? MAX_TRANSACTION_AMOUNT : MAX_TRANSACTION_AMOUNT * 2

          @current_transaction.transaction_amount > limit
        end
      end
    end
  end
end
